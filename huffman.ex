defmodule Huffman do

# get custom Tree and List implementations built from scratch
import Tree
import Lists

# this function returns text used to create an encoding table
def sample() do
  'the quick brown fox jumps over the lazy dog
  this is a sample text that we will use when we build
  up a table we will only handle lower case letters and
  no punctuation symbols the frequency will of course not
  represent english but it is probably not that far off'
end

# this function defines text that we will try to encode for testing
def text()  do
  'this is something that we should encode'
end


# here we tests our implementation with predefined inputs
def test(sample) do
  sample = sample()
  tree = tree(sample)
  encode = encode_table(tree)
  text = text()
  seq = encode(text, encode)
  decode(seq,tree,tree,[])
end

# entry point for function computing frequency
def freq(sample) do
  freq(sample, :nil)
end

# base case of recursion where we sort the frequencies
def freq([], freq) do
  Tree.ordered_by_value(freq)
end

# build recursively a tree data structure containing words as keys and word frequencies as values
def freq([char | rest], freq) do
  # insert the carachter and compute its value using the lookup function
  freq(rest, Tree.insertkey(char,Tree.lookup(char,freq)+1,freq))
end

# build the huffman tree used for encoding the input
def tree(sample) do
  freq = freq(sample)
  huffman(freq)
end

# base case of function building the huffman tree
def huffman([{tree,freq}|[]]) do tree end

# recursive step of building the huffman tree
def huffman([head1,head2|rest]) do
  # create a new tree whose children are the two top nodes
  newNode = build(head1,head2)
  # insert this new node in the list which is used for the next step
  huffman(insertnew(newNode,rest))
end

# create a new tree whose children are the two inputs
def build({char1,freq1},{char2,freq2}) do
{{char1, char2}, freq1 + freq2}
end

# base case of function inserting a new element in list of sorted frequencies
def insertnew(element, []) do
[element]
end

# recursive step to insert new element in list of sorted nodes
def insertnew({char1,freq1}, [{char2,freq2}|tail]) do
# if freq1 is smaller than freq2 we found the correct position, otherwise we do another recursive call
case freq1 < freq2 do
  false -> [{char2,freq2}|insertnew({char1,freq1},tail)]
  true -> [{char1,freq1},{char2,freq2}|tail]
end
end

# we traverse the tree and create a list of characters and their related encoding (binary sequence)
def encode_table(tree) do
  traverse(tree,[])
end

# when we do not have a leaf node we add 0/1 to the list and continue
def traverse({left,right},binary) do
  List.append(traverse(left,[0|binary]),traverse(right,[1|binary]))
end

# when we find a charachter we can add its encoding to the list (the binary code has to be reversed because of how it was created)
def traverse(leaf,binary) do
  [{leaf,Lists.reverse(binary)}]
end

# we build a tree structure from the list previously defined to achieve O(log(n)) lookup (encoding) time (recursive step)
def tree_table([{leaf,list}|rest],tree) do
  tree = insertkey(leaf,list,tree)
  tree_table(rest,tree)
end

# base case for building tree table
def tree_table([],tree) do
  tree
end

# entry point for function encoding text
def encode(text, table) do #this is gonna return the encoded text in reversed order
  encode(text,tree_table(table,:nil),[])
end

# recursive step of creating encoding
def encode([char|rest],table,encoding) do
  # we append the reverse of the code to have the short new sequence as the first argument of the append function (approximately O(1))
  encoding = List.append(List.reverse(Tree.lookup(char,table)),encoding)
  encode(rest,table,encoding)
end

# final step of creating encoding, we reverse result because we inserted encodings in reverted order to get better performance
def encode([],table,encoding) do
  List.reverse(encoding)
end

# recursive step of decoding
def decode([binary|rest],{left, right},topoftree,solution) do
  # if we have a zero we traverse the left branch, otherwise the right branch
  case binary == 0 do
    true -> decode(rest,left,topoftree,solution)
    false -> decode(rest,right,topoftree,solution)
  end
end

# when the sequence is finished we only need to reverse the result (because of how it was accumulated)
def decode([],{left, right},topoftree, solution) do
  List.reverse(solution)
end

# when we find a leaf we need to add the character found and reset the tree to the root
def decode(rest,leaf,topoftree, solution) do
  solution = [leaf|solution]
  decode(rest,topoftree,topoftree,solution)
end
end
