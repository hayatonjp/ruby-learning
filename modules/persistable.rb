module Persistable
    def load_tasks
        return unless File.exist?('tasks.json') && !File.empty?('tasks.json') # exist?はそのファイルがあるかどうか、empty?はそのファイルの中身が空かどうか

        begin   
            data = JSON.parse(File.read('tasks.json'))
            @tasks = data.map do |task_data|
                due_date = task_data['due_date'] ? Date.parse(task_data['due_date']) : nil
                task = Task.new(task_data['title'], task_data['priority'], due_date)
                task.completed = task_data['completed']
                task
            end
        rescue JSON::ParserError => e
            # JSON形式が不正の場合
            puts "error: JSON形式が不正です（#{e.message})"
            puts "tasks.jsonをバックアップして新規作成します"
            File.rename('tasks.json', "tasks_backup_#{Time.now.to_i}.json")
            @tasks = []
        rescue Errno::EACCES => e
            # ファイルの読み込み権限がない場合
            puts "error: ファイルの読み込み権限がありません"
            @tasks = []
        rescue StandardError => e
            # その他予期せぬエラー
            puts "error: タスクの読み込み中に問題が発生しました (#{e.class}: #{e.message})"
            @tasks = []
        end
    end

    def save_tasks
        data = @tasks.map do |task|
            { 
                title: task.title,
                completed: task.completed,
                priority: task.priority,
                due_date: task.due_date&.to_s # &はnilの場合にエラーを返さずにnilを返す演算子
            }
        end
        File.write('tasks.json', JSON.pretty_generate(data)) # pretty_generate: 見やすい形式で表示する
    end
end