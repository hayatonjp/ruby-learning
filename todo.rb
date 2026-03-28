require 'json'

class Task
    attr_accessor :title, :completed, :priority # クラス外部から変更したい定義 getter + setter, クラス内部でしか使わないならインスタンス変数でOK(例: tasks.title = "aa")

    def initialize(title, priority)
        @title = title
        @completed = false
        @priority = priority # "高", "中", "低"
    end

    def complete! # 状態変更するために!をつけている
        @completed = true
    end

    def to_s
        status = @completed ? "[完了]" : "[未完了]"
        "#{status} [#{@priority}] #{@title}"
    end

    def priority_value
        case @priority
            when "高" then 3
            when "中" then 2
            when "低" then 1
            else 0
        end
    end
end

class TodoApp
    def initialize
        @tasks = []
        load_tasks
    end

    def add_task_with_priority
        print "タスク名: "
        title = gets.chomp

        puts "優先度を選択（1:高, 2:中, 3:低）"
        print "> "
        priority_choice = gets.chomp

        priority = case priority_choice
        when "1" then "高"
        when "2" then "中"
        when "3" then "低"
        else "中"
        end

        @tasks << Task.new(title, priority)
        save_tasks
        puts "追加しました！"
    end

    def list_tasks_sorted
        if @tasks.empty?
            puts "タスクはありません"
        else
            # 優先度でソート（高い順）
            sorted_tasks = @tasks.sort_by { |task| -task.priority_value }
            sorted_tasks.each_with_index do |task, i|
                puts "#{i+1}. #{task}"
            end
        end
    end

    def load_tasks
        return unless File.exist?('tasks.json')

        data = JSON.parse(File.read('tasks.json'))
        @tasks = data.map do |task_data|
            task = Task.new(task_data['title'], task_data['priority'])
            task.completed = task_data['completed']
            task
        end
    end

    def save_tasks
        data = @tasks.map do |task|
            { 
                title: task.title,
                completed: task.completed,
                priority: task.priority
            }
        end
        File.write('tasks.json', JSON.pretty_generate(data)) # pretty_generate: 見やすい形式で表示する
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
                    add_task_with_priority
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