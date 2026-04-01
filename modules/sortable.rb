module Sortable
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
end