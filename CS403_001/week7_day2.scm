(define (node left right value)
  (define (dispatch msg)
    (cond
      ((eq? msg 'left) left)
      ((eq? msg 'right) right)
      ((eq? msg 'value) value)
      (else (error))
    )
  )
  dispatch
)

(define a (node nil nil 4))
(define b (node a nil 5))
(define c (node b a 6))

;@ current scope = this
(define (node left right value)
  this
)
;@ __context is the outer scope
;@ argList: expr
;@  | expr COMMA argList
function argList() {
  expr();
  if (check(COMMA)) {
    ;@ consume comma
    advance();
    argList();
  }
}

class lexeme {
  string type;
  int ival;
  string sval;
  lexeme left;
  lexeme right;
}

;@ Make a notebook and for each rule, the bulk of the page
;@  is what the parse tree for the rule (such as functions)
;@  looks like



;@ expr: primary
;@  | primary OP expr

function expr() {
  var a, b, c;
  }

funcDef: ID OPAREN optParamList CPAREN block

function funcDef() {
  var a, b, c;
  a = match(ID);
  match(OPAREN);
  b = optParamList();
  match(CPAREN);
  c = block();
}

the parse tree:
[name |
  [params |
    [body]]]
return cons(FUNCDEF, a, cons(JOIN, b, cons(JOIN, c null)))
;@ every function will return a parse tree
