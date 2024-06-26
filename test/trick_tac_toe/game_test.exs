defmodule TrickTacToe.GameTest do
  use ExUnit.Case, async: true

  alias TrickTacToe.{Board, Game}

  describe "new/1" do
    test "creates a new game" do
      assert %Game{
               id: 1,
               moves: [],
               players: %{x: false, o: false},
               status: :incomplete
             } = Game.new(1)
    end
  end

  describe "join/2" do
    test "join empty game" do
      assert {:ok,
              %Game{
                players: %{x: true}
              }} = Game.join(Game.new(1), :x)
    end

    test "join game with room" do
      game = %Game{players: %{x: false, o: true}}

      assert {:ok,
              %Game{
                players: %{x: true, o: true}
              }} =
               Game.join(game, :x)

      game = %Game{players: %{x: true, o: false}}

      assert {:ok,
              %Game{
                players: %{x: true, o: true}
              }} =
               Game.join(game, :o)
    end
  end

  describe "available_players/1" do
    test "with x available" do
      game = %Game{players: %{x: false}}
      assert :x in Game.available_players(game)
    end

    test "with o available" do
      game = %Game{players: %{o: false}}
      assert :o in Game.available_players(game)
    end

    test "with neither available" do
      game = %Game{players: %{o: true, x: true}}
      assert [] == Game.available_players(game)
    end
  end

  describe "get_board/1" do
    test "reduces moves" do
      game = %Game{
        moves: [
          {:x, :a1},
          {:o, :b1},
          {:x, :c3},
          {:o, :a2}
        ]
      }

      assert %Board{
               a1: :x,
               a2: :o,
               b1: :o,
               c3: :x
             } == Game.get_board(game)
    end
  end

  describe "get_turn/1" do
    test "with an empty board" do
      game = %Game{
        moves: []
      }

      assert :x == Game.get_turn(game)
    end

    test "with last move by x" do
      game = %Game{
        moves: [
          {:x, :c3},
          {:o, :b1},
          {:x, :a1}
        ]
      }

      assert :o == Game.get_turn(game)
    end

    test "with last move by o" do
      game = %Game{
        moves: [
          {:o, :b2},
          {:x, :c3},
          {:o, :b1},
          {:x, :a1}
        ]
      }

      assert :x == Game.get_turn(game)
    end
  end

  describe "make_move/2" do
    test "when less than 5 moves" do
      moves = [
        {:x, :c3},
        {:o, :b1},
        {:x, :a1}
      ]

      assert {:ok,
              %Game{
                moves: [{:o, :b3} | ^moves]
              }} =
               Game.make_move(%Game{moves: moves}, {:o, :b3})
    end

    test "when 5 moves" do
      moves = [
        {:o, :b2},
        {:x, :c3},
        {:o, :b1},
        {:x, :a1}
      ]

      assert {:ok,
              %Game{
                moves: [
                  {:x, :c2},
                  {:o, :b2},
                  {:x, :c3},
                  {:o, :b1}
                ]
              }} =
               Game.make_move(%Game{moves: moves}, {:x, :c2})
    end

    test "when move finishes game" do
      moves = [
        {:o, :b2},
        {:x, :a2},
        {:o, :b1},
        {:x, :a1}
      ]

      assert {:ok,
              %Game{
                moves: [{:x, :a3} | ^moves],
                status: {:winner, :x}
              }} = Game.make_move(%Game{moves: moves}, {:x, :a3})
    end

    test "when position is taken" do
      moves = [
        {:o, :b2},
        {:x, :a2},
        {:o, :b1},
        {:x, :a1}
      ]

      assert {:error, :position_taken} = Game.make_move(%Game{moves: moves}, {:x, :a1})
    end

    test "when not player's turn" do
      moves = [
        {:x, :a2},
        {:o, :b1},
        {:x, :a1}
      ]

      assert {:error, :wrong_player} = Game.make_move(%Game{moves: moves}, {:x, :a3})
    end

    test "when game already finished" do
      game = %Game{
        status: {:winner, :x},
        moves: [
          {:x, :a3},
          {:o, :b2},
          {:x, :a2},
          {:o, :b1},
          {:x, :a1}
        ]
      }

      assert {:error, :game_over} = Game.make_move(game, {:o, :b3})
    end
  end
end
