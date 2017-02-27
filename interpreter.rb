input = ARGV[0]

$valid_commands = [">","<","+","-",".",",","[","]"]
$program_source = []

File.open(input, "r") do |f|
  f.each_char { |c| $program_source.push(c) if $valid_commands.include? c }
end

$instruction_pointer = 0
$data_pointer = 0
$mem = []

def increment_data_pointer()
  $data_pointer += 1
end

def decrement_data_pointer()
  $data_pointer -= 1
end

def increment_byte()
  $mem[$data_pointer] ||= 0b00000000
  $mem[$data_pointer] += 0b00000001
end

def decrement_byte()
  $mem[$data_pointer] ||= 0b00000000
  $mem[$data_pointer] -= 0b00000001
end

def output_byte()
  print $mem[$data_pointer].chr
end

def get_byte()
  $mem[$data_pointer] = STDIN.read(1)
end

def jump_forwards()
  if $mem[$data_pointer] == 0
    inner_brackets = 0
    $instruction_pointer += 1
    until $program_source[$instruction_pointer] == "]" && inner_brackets == 0 do
      inner_brackets += 1 if $program_source[$instruction_pointer] == "["
      inner_brackets -= 1 if inner_brackets > 0 && $program_source[$instruction_pointer] == "]"
      $instruction_pointer += 1
    end
    $instruction_pointer += 1
  else
    increment_instruction
  end
end

def jump_backwards()
  if $mem[$data_pointer] != 0
    inner_brackets = 0
    $instruction_pointer -= 1
    until $program_source[$instruction_pointer] == "[" && inner_brackets == 0 do
      inner_brackets += 1 if $program_source[$instruction_pointer] == "]"
      inner_brackets -= 1 if inner_brackets > 0 && $program_source[$instruction_pointer] == "["
      $instruction_pointer -= 1
    end
    $instruction_pointer += 1
  else
    increment_instruction
  end
end

def increment_instruction()
  $instruction_pointer += 1
end

until $instruction_pointer >=  $program_source.count do
  command = $program_source[$instruction_pointer]
  case command
    when ">"
      increment_data_pointer
      increment_instruction
    when "<"
      decrement_data_pointer
      increment_instruction
    when "+"
      increment_byte
      increment_instruction
    when "-"
      decrement_byte
      increment_instruction
    when "."
      output_byte
      increment_instruction
    when ","
      get_byte
      increment_instruction
    when "["
      jump_forwards
    when "]"
      jump_backwards
  end
end
