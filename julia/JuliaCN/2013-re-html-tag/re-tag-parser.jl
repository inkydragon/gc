txt = """
<div class="goal" not_only_these_elements>
  <div>something here
  <div>anything here</div>
  </div>
<div>nothing here </div>
</div>
<div class="trouble">catch me is error</div>
"""

using Cascadia
using Gumbo

n=parsehtml(txt)
@show eachmatch(sel"div.goal", n.root)
# 1-element Array{HTMLNode,1}:
#  HTMLElement{:div}:
# <div class="goal"not_only_these_elements="">
#   <div>
#     something here
#     <div>
#       anything here
#     </div>
#   </div>
#   <div>
#     nothing here
#   </div>
# </div>

@show eachmatch(sel"div.goal > div", n.root)
# 2-element Array{HTMLNode,1}:
#  HTMLElement{:div}:
# <div>
#   something here
#   <div>
#     anything here
#   </div>
# </div>
# 
#  HTMLElement{:div}:
# <div>
#   nothing here
# </div>

@show eachmatch(sel"div.goal > div", n.root)[2].children
# 1-element Array{HTMLNode,1}:
#  HTML Text: nothing here

print(eachmatch(sel"div.goal > div", n.root)[2].children[1])
# nothing here