# frozen_string_literal: true

for i in [1, 2, 3] do
  puts 'hello'
end

puts(<<~HEREDOC)
hello
HEREDOC

puts(<<-HEREDOC)
hello
HEREDOC

<<-HEREDOC
hello
HEREDOC

def do_something
  puts 'hello'
rescue
  puts 'world'
end

def f(**b); end
def f(*c); end

value = true ? false : true

def f(a, b: c); end
