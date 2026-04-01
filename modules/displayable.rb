module Displayable
    def list_tasks
        if @tasks.empty?
            puts "タスクはありません"
        else
            @tasks.each_with_index do |task, i|
                puts "#{i + 1}, #{task}"
            end
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
end