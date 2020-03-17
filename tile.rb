class Tile
    def initialize
        @type = nil
        @symbol = nil
        @face_up = false
        determine_type
    end

    attr_reader :type, :symbol

    def determine_type
        n = rand(1..10)
        if n > 9
            @type = "bomb" 
            @symbol = "*"
        else
            @type = "safe"
            @symbol = "s"
        end
    end

    def flip
        @face_up = !@face_up
    end

    def flipped
        if @face_up == true
            @symbol
        else
            "~"
        end
    end

end