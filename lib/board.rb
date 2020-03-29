class Board

  attr_accessor :cells, :free_cells

  def setup(cells: nil, free_cells: 42)
    @free_cells = free_cells
    @cells = cells || (0..6).collect do
      (0..5).collect do
        Cell.new(content:" ")
      end
    end
  end

  def display_to_screen
    5.downto(0) do |i|
      7.times do |j|
        print "|"
        print @cells[j][i]
      end
      puts "|"
    end
    puts "---------------"
    puts "|1|2|3|4|5|6|7|"
  end

  def set_cell(content:, col:)
    row = find_free_cell(col)

    return false if !row

    @cells[col][row].content = content
    @free_cells -= 1

    return true
  end

  def game_over?(last_move_col)
    last_move_row = find_occupied_row(last_move_col)
    check_vertical(last_move_col, last_move_row) or
    check_horizontal(last_move_col, last_move_row) or
    check_diagonal(last_move_col, last_move_row)
  end

  def full?
    free_cells <= 0
  end

  private

  def find_occupied_row(col)
    # returns the index of the topmost occupied row in the given col
    index = find_free_cell(col)
    return 5 if index.nil?
    index - 1
  end

  def find_free_cell(col)
    # return the first empty cell in the column
    @cells[col].find_index { |cell| cell.content == " " }
  end


  def check_vertical(col, row)
    if row <= 2
      # it cannot be four in a row until there are at least 4 cells
      false
    else
      # check if all three cells below are equal to the current
      slice = @cells[col][row-3..row].collect do |cell|
        cell.content
      end
      slice.uniq.count == 1
    end
  end

  def check_horizontal(col, row)
    # take the contents of each cell in the row into a single array
    row_content = @cells.collect { |column| column[row].content }

    # make a string out of it
    string = row_content.join("")
    # match four consecutive characters, excluding whitespace
    /([^\s])\1{3}/.match?(string)
  end

  def check_diagonal(col, row)
    # first, walk diagonally form the starting point to the top left and
    # bottom left, until you reach an endpoint
    diag_1 = [col, row]
    loop do
      break if diag_1[0] == 0
      break if diag_1[1] == 5
      diag_1 = [diag_1[0]-1, diag_1[1]+1]
    end
    diag_2 = [col, row]
    loop do
      break if diag_2[0] == 0
      break if diag_2[1] == 0
      diag_2 = [diag_2[0]-1, diag_2[1]-1]
    end

    # then, start from the determined starting points and go diagonally
    diag_1_content = "" 
    loop do
      diag_1_content << @cells[diag_1[0]][diag_1[1]].content
      # add to both to go diagonally
      diag_1[0] += 1
      diag_1[1] -= 1

      # break out if we have reached an end
      break if diag_1[0] > 6
      break if diag_1[1] < 0
    end

    # return true already here if four in a row are found
    r = Regexp.new('([^\s])\1{3}')
    return true if r.match?(diag_1_content)

    # for the second diagonal start form the top left cell and go
    # downwards diagonally
    diag_2_content = ""
    loop do
      diag_2_content << @cells[diag_2[0]][diag_2[1]].content
      diag_2[0] += 1
      diag_2[1] += 1

      break if diag_2[0] > 6
      break if diag_2[1] > 5
    end

    r.match?(diag_2_content)
  end
end
