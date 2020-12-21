defmodule Lists do

# get list length
def len([]) do
  0
end

def len([head|tail]) do
  len(tail) + 1
end

# remove a given element from a list
def remove(x,[]) do
  []
end

def remove(x,[head|tail])do
  case head == x do
    false -> [head|remove(x,tail)]
    true -> remove(x,tail)
  end
end

# append two lists into a new list
def append([],list) do
  list
end

def append([head|tail] , list) do
  [head | append(tail,list)]
end

# O(n) tail recursive implementation of reversing a list
def reverse(l) do
  reverse(l, [])
end

def reverse([], r) do r end

def reverse([h | t], r) do
  reverse(t, [h | r])
end

end
