class SlotGame
  @@coin = 100
  @@point = 0

  # 加算ポイント・コイン数を管理する定数
  HIT_SCORE_SETTINGS = {
    high: {
      point: 500,
      coin: 100
    },
    middle: {
      point: 100,
      coin: 30
    },
    low: {
      point: 50,
      coin: 20
    }
  }

  PLAY_TYPES = ["1", "2", "3", "4"]
  QUIT_COMMAND = "4"

  # ゲームに必要なコイン数を管理する定数
  PLAY_SETTINGS = {
    "1": {
      coin: 10
    },
    "2": {
      coin: 30
    },
    "3": {
      coin: 50
    }
  }

  def roll(i, play_type)
    case play_type
    when "1"
      return rand(1..9), rand(1..9), rand(1..9)
    when "2"
      return rand(1..5), rand(1..5), rand(1..5)
    when "3"
      if i == 2
        return rand(1..9), rand(3..7), rand(1..9)
      end
      return rand(1..9), 7, rand(1..9)
    end
  end

  def start_rolling(play_type)
    line_1 = ["", "", ""]
    line_2 = ["", "", ""]
    line_3 = ["", "", ""]

    puts "エンターを3回入力しましょう。"

    3.times do |i|
      # 繰り返し処理ごとにエンターの入力を受け付けています
      gets

      result = roll(i, play_type)

      line_1[i], line_2[i], line_3[i] = result[0], result[1], result[2]

      puts "ーーーーーーーーーー"
      puts "|#{line_1[0]}|#{line_1[1]}|#{line_1[2]}|"
      puts "|#{line_2[0]}|#{line_2[1]}|#{line_2[2]}|"
      puts "|#{line_3[0]}|#{line_3[1]}|#{line_3[2]}|"
    end

    # 横に揃っているかどうかを確認します
    calc_score_if_aligned_horizontally(lines: [line_1, line_2, line_3])

    # 斜めに揃っているかどうかを確認します
    calc_score_if_aligned_diagonally(line_1, line_2, line_3)

    # コインがない場合はゲームを終了します
    @@coin <= 0 ? game_over() : continue()
  end

  # 数字が横一列に揃っているかどうかを判定します
  def is_number_aligned_horizontally?(line)
    line.uniq.count == 1
  end

  # 7が横一列に揃っているかどうかを判定します
  def is_number_7_aligned_horizontally?(line)
    line.all? { |n| n == 7 }
  end

  # 数字が横一列に揃っている場合にポイントとコインを加算します
  def calc_score_if_aligned_horizontally(lines:)
    lines.each do |line|
      if is_number_7_aligned_horizontally?(line)
        puts "ーーーーーーーーーー"
        puts "7が揃いました!"
        calc_score_by(type: "high")
      elsif is_number_aligned_horizontally?(line)
        puts "ーーーーーーーーーー"
        puts "#{line[0]}が揃いました!"
        calc_score_by(type: "low")
      end
    end
  end

  # 数字が斜めに揃っている場合にポイントとコインを加算します
  def calc_score_if_aligned_diagonally(line_1, line_2, line_3)
    if (line_1[0] == line_2[1]) and (line_1[0] == line_3[2])
      puts "ーーーーーーーーーー"
      puts "#{line_1[0]}が斜めに揃いました!"
      calc_score_by(type: "middle")
    end

    if (line_3[0] == line_2[1]) and (line_3[0] == line_1[2])
      puts "ーーーーーーーーーー"
      puts "#{line_3[0]}が斜めに揃いました!"
      calc_score_by(type: "middle")
    end
  end

  def calc_score_by(type:)
    score = HIT_SCORE_SETTINGS[type.to_sym]
    point, coin = score[:point], score[:coin]

    puts "#{point}ポイント獲得!"
    puts "#{coin}コイン獲得!"

    increase_points_by(amount: point)
    increase_coins_by(amount: coin)
  end

  def increase_points_by(amount:)
    @@point += amount
  end

  def increase_coins_by(amount:)
    @@coin += amount
  end

  def decrease_coins_by(amount:)
    @@coin -= amount
  end

  def play()
    puts "ーーーーーーーーーーー"
    puts "残りコイン数は#{@@coin}コインです。"
    puts "現在のポイントは#{@@point}ポイントです。"
    puts "何コインいれますか？"
    puts "1: 10コイン 2: 30コイン 3: 50コイン 4: やめておく"
    puts "ーーーーーーーーーーー"

    play_type = gets.to_s.chomp

    if !PLAY_TYPES.include?(play_type)
      puts "入力値が不正です。再度ご確認ください。"
      play()
    end

    if play_type == QUIT_COMMAND
      quit_by_user()
    else
      return if @@coin == 0

      min_coin = PLAY_SETTINGS[play_type.to_sym][:coin]

      if @@coin < min_coin
        puts "コインが足りません。"
        continue()
      else
        decrease_coins_by(amount: min_coin)
        start_rolling(play_type)
      end
    end
  end

  def continue()
    play()
  end

  def quit_by_user()
    puts "また遊びましょう！"
    puts "あなたの最終ポイントは#{@@point}ポイントです。"
  end

  def game_over()
    puts "コインがなくなりました。"
    puts "あなたの最終ポイントは#{@@point}ポイントです。"
  end
end

# スロットゲームを始めます
slot_game = SlotGame.new
slot_game.play()