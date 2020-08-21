;How to use
;Put you numerical values in the input section
;Set the last number -9999 so that the program knows to stop inserting values
         BR      main 
data:    .EQUATE 0           ; setting up node struct
left:    .EQUATE 2
right:   .EQUATE 4
;
;*****   insert(int value, node *node) returns temp
temp:    .EQUATE 6
node:    .EQUATE 4
value:   .EQUATE 2
insert:  LDWA    node,s      ;if(node = 0) checks if node as been initialized with malloc
         CPWA    0,i
         BRNE    chckrt     
         LDWA    6,i         ;inizialize temp with malloc
         CALL    malloc      
         STWX    temp,s
         LDWA    value,s     ;temp->data = value
         LDWX    data,i
         STWA    temp,sfx
         RET                 ;return temp
chckrt:  LDWX    data,i      ;if(node->data < value) 
         LDWA    node,sfx
         CPWA    value,s
         BRGE    chcklf
         LDWX    right,i     ;put node->right on stack
         LDWA    node,sfx
         STWA    -4,s        ;put value on stack
         LDWA    value,s 
         STWA    -6,s
         SUBSP   6,i         ;call insert(value, node->right)
         CALL    insert
         ADDSP   6,i
         LDWA    -2,s        ;node->right = returned node (temp)
         LDWX    right,i
         STWA    node,sfx
         LDWA    node,s      ;temp = node
         STWA    temp,s 
         RET                 ;return temp
chcklf:  LDWX    data,i      ;if(node->data > value)
         LDWA    node,sfx    
         CPWA    value,s
         BRLE    fin
         LDWX    left,i      ;put node->left on stack
         LDWA    node,sfx
         STWA    -4,s        ;put value on stack
         LDWA    value,s 
         STWA    -6,s
         SUBSP   6,i         ;call insert(value, node->left)
         CALL    insert
         ADDSP   6,i
         LDWA    -2,s        ;node->left = returned node (temp)
         LDWX    left,i
         STWA    node,sfx
         LDWA    node,s      ;temp = node 
         STWA    temp,s 
fin:     RET                 ;return temp
;
;        inorder(node* node)      prints binary tree using inorder traversal
innode:  .EQUATE 2
inord:   LDWA    innode,s         ;if(node = 0) ret checks if node as been initialized with malloc
         CPWA    0,i
         BRNE    inprin
         RET
inprin:  LDWX    left,i           ;puts the left node on the stack
         LDWA    innode,sfx
         STWA    -2,s
         SUBSP   2,i              ;calls inorder using the left node
         CALL    inord 
         ADDSP   2,i
         LDWX    data,i           ;prints out value stored in the current node
         DECO    innode,sfx
         LDBA    ' ',i 
         STBA    charOut,d
         LDWX    right,i          ;puts the right node on the stack
         LDWA    innode,sfx 
         STWA    -2,s
         SUBSP   2,i              ;calls inorder using the right node
         CALL    inord 
         ADDSP   2,i
         RET
;
;        preorder(node* node)      prints binary tree using preorder traversal
prenode: .EQUATE 2
preord:  LDWA    prenode,s        ;if(node = 0) ret checks if node as been initialized with malloc
         CPWA    0,i
         BRNE    preprin
         RET
preprin: LDWX    data,i           ;prints out value stored in the current node
         DECO    prenode,sfx
         LDBA    ' ',i 
         STBA    charOut,d
         LDWX    left,i           ;puts the left node on the stack
         LDWA    prenode,sfx
         STWA    -2,s
         SUBSP   2,i              ;calls preorder using the left node
         CALL    preord 
         ADDSP   2,i
         LDWX    right,i          ;puts the right node on the stack
         LDWA    prenode,sfx
         STWA    -2,s
         SUBSP   2,i              ;calls preorder using the right node
         CALL    preord 
         ADDSP   2,i
         RET                      ;return
;
;        postorder(node* node)      prints binary tree using postorder traversal
postnode:.EQUATE 2
postord: LDWA    postnode,s        ;if(node = 0) ret checks if node as been initialized with malloc
         CPWA    0,i
         BRNE    postprin
         RET
postprin:LDWX    left,i           ;puts the left node on the stack
         LDWA    postnode,sfx
         STWA    -2,s
         SUBSP   2,i              ;calls postorder using the left node
         CALL    postord 
         ADDSP   2,i
         LDWX    right,i          ;puts the right node on the stack
         LDWA    postnode,sfx
         STWA    -2,s
         SUBSP   2,i              ;calls preorder using the right node
         CALL    postord 
         ADDSP   2,i
         LDWX    data,i           ;prints out value stored in the current node
         DECO    postnode,sfx
         LDBA    ' ',i 
         STBA    charOut,d
         RET
;
;*****   main ()
root:    .EQUATE 2
val:     .EQUATE 0 
main:    SUBSP   4,i         ;push root, value
         DECI    val,s       ;read first input
while:   LDWA    val,s       ;while(val != -9999)
         CPWA    -9999,i
         BREQ    endWh
         LDWA    root,s      ;put root on stack
         STWA    -4,s
         LDWA    val,s       ;put val on stack
         STWA    -6,s
         SUBSP   6,i         ;call insert
         CALL    insert
         ADDSP   6,i
         LDWA    -2,s        ;root = returned node  
         STWA    root,s 
         DECI    val,s       ;read next input val
         BR      while      
endWh:   LDWA    root,s      ;put rooton stack
         STWA    -2,s
         STRO    msgin,d     ;output Inorder Print:
         SUBSP   2,i         ;call inorder traversal
         CALL    inord
         ADDSP   2,i
         LDBA    '\n',i 
         STBA    charOut,d
         STRO    msgpre,d    ;output Preorder Print:
         SUBSP   2,i         ;call preorder traversal
         CALL    preord
         ADDSP   2,i
         LDBA    '\n',i 
         STBA    charOut,d
         STRO    msgpost,d   ;output Postorder Print:
         SUBSP   2,i         ;call postorder traversal
         CALL    postord
         ADDSP   2,i
         ADDSP   4,i         ;pop val root
         STOP
;
         msgin:    .ASCII  "Inorder Print: \x00"
         msgpre:   .ASCII  "Preorder Print: \x00"
         msgpost:  .ASCII  "Postorder Print: \x00"
;
;*****   malloc()
malloc:  LDWX    hpPtr,d     ;returned pointer
         ADDA    hpPtr,d     ;allocate from heap
         STWA    hpPtr,d     ;update
         RET
hpPtr:   .ADDRSS heap        ;address of next free byte
heap:    .BLOCK  1           ;first byte in the heap
         .END