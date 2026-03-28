require 'json'

class Task
    attr_accessor :title, :completed # クラス外部から変更したい定義 getter + setter, クラス内部でしか使わないならインスタンス変数でOK(例: tasks.title = "aa")

    def initialize(title)
        @title = title
        @completed = false
    end

    def complete! # 状態変更するために!をつけている
        @completed = true
    end

    def to_s
        status = @completed ? "[完了]" : "[未完了]"
        "#{status} #{@title}"
    end
end

class TodoApp
    def initialize
        @tasks = []
        load_tasks
    end

    def load_tasks
        return unless File.exist?('tasks.json')

        data = JSON.parse(File.read('tasks.json'))
        @tasks = data.map do |task_data|
            task = Task.new(task_data['title'])
            task.completed = task_data['completed']
            task
        end
    end

    def save_tasks
        data = @tasks.map do |task|
            { title: task.title, completed: task.completed }
        end
        File.write('tasks.json', JSON.pretty_generate(data)) # pretty_generate: 見やすい形式で表示する
    end

    def add_task(title)
        @tasks << Task.new(title)
        save_tasks
    end

    def list_tasks
        if @tasks.empty?
            puts "タスクはありません"
        else
            @tasks.each_with_index do |task, i|
                puts "#{i + 1}, #{task}"
            end
        end
    end

    def complete_task(index)
        if index >= 0 && index < @tasks.length
            @tasks[index].complete!
            puts "タスクを完了にしました！"
            save_tasks
        else
            puts "無効な番号です"
        end
    end

    def show_menu
        puts "\n==タスク管理=="
        puts "1. タスク追加"
        puts "2. タスク一覧"
        puts "3. タスク完了"
        puts "4. 終了"
        print "選択: "
    end

    def run
        loop do
            show_menu
            choice = gets.chomp # getsで入力値を受け取り、chompで改行削除

            case choice
                when "1"
                    print "タスク名: "
                    title = gets.chomp
                    add_task(title)
                when "2"
                    list_tasks
                when "3"
                    list_tasks
                    print "完了するタスクの番号: "
                    index = gets.chomp.to_i - 1
                    complete_task(index)
                when "4"
                    break
            end
        end
    end
end

app = TodoApp.new
app.run