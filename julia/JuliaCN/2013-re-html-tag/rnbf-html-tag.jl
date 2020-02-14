using RBNF

struct HTML end
RBNF.@parser HTML begin
    ignore{}
    reserved = []

    @grammar
    # define grammar rules
    tag_pair := [tag_open, p=Content.?, tag_close]
    tag_open    := ['<',  tag=:div, attrs=attr_list.?, ws.?, '>']
    Content     := (id | ws){*}
    tag_close   := ['<', '/', tag=:div, ws.?, '>']
    
    attr_list   := [ws, attr]{*}
    attr        := attr_empty | attr_double_quoted
    attr_empty          := attr_name
    attr_double_quoted  := [attr=:class, '=', val=str]
    attr_name = id
    
    @token
    # define tokenizers as well as their corresponding lexers
    id        := r"\G[a-z]{1}[A-Za-z0-9_]*"
    str       := @quote ("\"" ,"\\\"", "\"")
    nninteger := r"\G([1-9]+[0-9]*|0)"
    ws        := r"\G\s+"
end

source_code = """
<div class="goal" not_only_these_elements>
  <div>something here
  <div>anything here</div>
  </div>
<div>nothing here </div>
</div>
<div class="trouble">catch me is error</div>
"""

sc2 = """<div class="trouble">catch me is error</div>"""


tokens = RBNF.runlexer(HTML, sc2)
ast, ctx = RBNF.runparser(tag_pair, tokens)

