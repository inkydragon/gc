module M

import Base.show_unquoted

macro show2(ex)
   quote
       print($(sprint(show_unquoted, ex)*" => "))
       show($(esc(ex)))
       println()
   end
end

end