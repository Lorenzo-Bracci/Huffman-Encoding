defmodule Tree do
  
# look for an element in the tree 
def lookup(_, :nil) do :nil end
def lookup(key, {:node, key,value, _, _}) do  value end
def lookup(e, {:node, key,value, left, _}) when e < key do
     lookup(e, left)
end
def lookup(e, {:node, _, _, _, right})  do
     lookup(e, right)
end

# insert key/value pair in the tree
def insertkey(newkey,newval, :nil)  do  {:node, newkey,newval,:nil,:nil}  end
def insertkey(newkey,newval, {:node, key,val, left, right }) when newkey < key do
   {:node,key,val,insertkey(newkey,newval,left),right}
end
def insertkey(newkey,newval, {:node, key,val, left, right }) when newkey > key do
   {:node,key,val,left,insertkey(newkey,newval,right)}
end
def insertkey(newkey,newval, {:node, newkey,val, left, right })  do
   {:node,newkey,newval,left,right}
end

# result of inorder tree traveral
def inorder(:nil) do [] end
def inorder({:node, key,value, left, right}) do
append(inorder(left),[{key,value}|inorder(right)])
end

# merge sort implementation
def msort(list) do
    case list do
      [] -> :no
        [head|[]] -> [head]
        [head|tail] ->
            {list1, list2} = msplit(list, [], [])
            merge(msort(list1), msort(list2))
    end
end

def merge([], list2) do list2 end
def merge(list1, []) do list1 end
def merge([{key1,value1}|tail1], [{key2,value2}|tail2]) do
    if value1 <= value2 do
        [{key1,value1}|merge(tail1, [{key2,value2}|tail2])]
    else
    [{key2,value2}|merge([{key1,value1}|tail1], tail2)]
      end
end
def msplit(list, list1, list2) do
    case list do
        []  -> {list1, list2}
        [head] -> {[head|list1], list2}
        [head1,head2|tail] -> msplit(tail, [head1|list1], [head2|list2])
    end
end

# list of elements in a tree sorted by value
def ordered_by_value({:node, key,value, left, right}) do
  msort(inorder({:node, key,value, left, right}))
end

end
