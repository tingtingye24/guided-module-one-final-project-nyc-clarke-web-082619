def displaycard(array)
  lines = Array.new(9){Array.new(array.length)}
  array.each_with_index{|card,index|
  charArray = card.split("")
  num= charArray[0]
  suit = charArray[1]
  
          lines[0][index]=("┌─────────┐")
          lines[1][index]=("│#{num}#{suit}       │")  # use two {} one for char, one for space or char
          lines[2][index]=("│         │")
          lines[3][index]=("│         │")
          lines[4][index]=("│    #{suit}    │")
          lines[5][index]=("│         │")
          lines[6][index]=("│         │")
          lines[7][index]=("│       #{num}#{suit}│")
          lines[8][index]=("└─────────┘")
  }
  lines.each_with_index{|item, index|
    item.each_with_index{|item2, index2|
    print lines[index][index2]
    }
    puts ""
  }
  end
  
  displaycard(["3^","6#","9%"])