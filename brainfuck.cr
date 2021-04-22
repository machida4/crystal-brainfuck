class BrainFuck
  @code : String
  @code_ptr : Int32
  @buff : Array(Int32)
  @buff_ptr : Int32
  @code_ptr_stack : Array(Int32)
  @clause_pairs : Hash(Int32, Int32)

  def initialize(source : String)
    @code = strip(source)
    @code_ptr = 0
    @buff = Array.new(30000, 0)
    @buff_ptr = 0
    @code_ptr_stack = [] of Int32
    @clause_pairs = clause_pairs
  end

  def execute
    until @code_ptr >= @code.size
      step
    end
  end

  private def strip(source : String)
    source.gsub(/[^+-><.,\[\]]+/, "")
  end

  private def clause_pairs
    stack = [] of Int32
    res = {} of Int32 => Int32

    @code.size.times do |index|
      case @code[index]
      when '['
        stack.push(index)
      when ']'
        res[stack.pop] = index
      end
    end

    res
  end

  private def step
    case @code[@code_ptr]
    when '+'
      buff_incr
    when '-'
      buff_decr
    when '>'
      buff_ptr_incr
    when '<'
      buff_ptr_decr
    when '.'
      print_buff
    when ','
      get_buff
    when '['
      goto_loopend
    when ']'
      goto_loopstart
    end

    @code_ptr += 1
  end

  private def buff_incr
    @buff[@buff_ptr] += 1
  end

  private def buff_decr
    @buff[@buff_ptr] -= 1
  end

  private def buff_ptr_incr
    @buff_ptr += 1
  end

  private def buff_ptr_decr
    @buff_ptr -= 1
  end

  private def print_buff
    print @buff[@buff_ptr].chr
  end

  private def get_buff
    @buff[@buff_ptr] = gets.to_s.to_i
  end

  private def goto_loopend
    if @buff[@buff_ptr] == 0
      @code_ptr = @clause_pairs[@code_ptr]
    else
      @code_ptr_stack.push(@code_ptr)
    end
  end

  private def goto_loopstart
    @code_ptr = @code_ptr_stack.pop - 1
  end
end
