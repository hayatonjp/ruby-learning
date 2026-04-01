require 'json'
require 'date'

# require_relativeは相対パスでの参照
require_relative 'modules/persistable'
require_relative 'modules/sortable'
require_relative 'modules/displayable'

class Task
    attr_accessor :title, :completed, :priority, :due_date # クラス外部から変更したい定義 getter + setter, クラス内部でしか使わないならインスタンス変数でOK(例: tasks.title = "aa")

    def initialize(title, priority = '小', due_date = nil)
        @title = title
        @completed = false
        @priority = priority # "高", "中", "低"
        @due_date = due_date # Date Object
    end

    def overdue?
        return false if @completed || @due_date.nil?
        @due_date < Date.today
    end

    def complete! # 状態変更するために!をつけている
        @completed = true
    end

    def to_s
        status = @completed ? "[完了]" : "[未完了]"
        priority_str = "[#{@priority}]"

        date_str = if @due_date
            due = @due_date.strftime('%m/%d')
            if overdue?
                " 期限: #{due} 期限切れ"
            else
                " 期限: #{due}"
            end
        else
            ""
        end 
        "#{status} #{priority_str} #{@title}#{date_str}"
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
    include Persistable
    include Sortable
    include Displayable

    def initialize
        @tasks = []
        load_tasks
    end

    def add_task_with_details
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

        print "期限を設定しますか？ (y/n): "
        if gets.chomp.downcase == "y"
            print "期限（YYYY-MM-DD）: "
            date_str = gets.chomp
            begin
                due_date = Date.strptime(date_str, '%Y-%m-%d')
            rescue ArgumentError
                puts "日付の形式が正しくありません。YYYY-MM-DD形式で入力してください。期限なしで登録します。"
                due_date = nil
            end
        else
            due_date = nil
        end

        @tasks << Task.new(title, priority, due_date)
        save_tasks
        puts "追加しました！"
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

    def run
        loop do
            show_menu
            choice = gets.chomp # getsで入力値を受け取り、chompで改行削除

            case choice
                when "1"
                    add_task_with_details
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