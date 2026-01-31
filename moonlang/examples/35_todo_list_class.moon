# REQUIRES: File system (json file)
# Todo List Manager class

class TodoList:
    function init(filename):
        self.filename = filename
        if exists(filename):
            self.todos = json_decode(read_file(filename))
        else:
            self.todos = []
        end
    end
    
    function add(task):
        item = {
            "id": len(self.todos) + 1,
            "task": task,
            "done": false,
            "created": date_format(time(), "%Y-%m-%d %H:%M")
        }
        append(self.todos, item)
        self.save()
        print("Added:", task)
    end
    
    function complete(id):
        for todo in self.todos:
            if todo["id"] == id:
                todo["done"] = true
                self.save()
                print("Completed:", todo["task"])
                return
            end
        end
    end
    
    function list():
        print("=== Todo List ===")
        for todo in self.todos:
            status = "[x]" if todo["done"] else "[ ]"
            print(status, todo["id"], "-", todo["task"])
        end
    end
    
    function save():
        write_file(self.filename, json_encode(self.todos))
    end
end

todos = new TodoList("todos.json")
todos.add("Learn MoonLang")
todos.add("Build a project")
todos.list()
todos.complete(1)
todos.list()
