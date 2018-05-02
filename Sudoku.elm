module Sudoku exposing (main
    , initialModel
    , init
    , matrixToSvg
    , makeBoard
    , sudokuValidation
    , checkList
    )


import Matrix exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (..)
import Html exposing (..)
import Html.Attributes exposing (placeholder,size,form)
import Html.Events exposing (..)


main : Program Never Model Msg
main = 
  Html.beginnerProgram
    { model = initialModel
    , view = view
    , update = update
    }


type alias Coord = 
    {x : Float, y : Float}

type alias Model =
  { board : Matrix Tile,
    input : Int,
    inputX : Int,
    inputY : Int,
    isValid : Bool
  }

type Tile = Blank --Blank tile
    | T Int --Mutable tile
    | P Int --Persistant tile, val cannot be changed by user

type Msg = 
    ValInput String
    | XInput String
    | YInput String
    | UpdateBoard
    | ValidateBoard
    | Reset

init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)

initialModel : Model
initialModel =
  { board = Matrix.map tupleToTile (Matrix.fromList makeBoard),
    input = -1,
    inputX = -1,
    inputY = -1,
    isValid = False
  }


--Helper functions
-----------------------------------------------------------------
--Comparable list containing 1-9 in ascending order
compareList : List Int
compareList =
    List.range 1 9

--Helper function comparing list of ints to 1-9 ascending
validList : List Int -> Bool
validList m =
        if m == compareList then --compare against [1-9]
            True
        else
            False

--Function to index a List, taken from List.extra library
getAt : List a -> Int -> Maybe a
getAt xs idx = List.head <| List.drop idx xs

--Function to check if False is in set of bools
checkList : List Bool -> Bool
checkList m =
    let valid = List.member False m in
        case valid of
            True -> False
            False -> True

-------------------------------------------------------------------


--Overall sudoku solution validation
sudokuValidation : Model -> Int -> List Bool
sudokuValidation model i =
    let m = toIntegerMatrix model.board in 
    case i of
        0 -> (rowsValid m 0) ++ (sudokuValidation model 1)
        1 -> (columnsValid m 0) ++ (sudokuValidation model 2)
        2 -> (squaresValid m 0 0) ++ (sudokuValidation model 3)
        _ -> []

--Square validation methods
--------------------------------------------------------------------------------------------------
--Helper function that takes a starting index (x,y), and puts the values in a 3x3 square around it, with (x,y) being the top left corner of the square, into a list
squareDriver : Matrix Int -> Int -> Int -> (Int,Int) -> List Int
squareDriver m i j (x,y) =
    if j < 3 then
        if i < 2 then
            [Maybe.withDefault -1 (get(loc (x+i) (y+j)) m)] ++ squareDriver m (i+1) j (x,y)
        else
            [Maybe.withDefault -1 (get(loc (x+i) (y+j)) m)] ++ squareDriver m 0 (j+1) (x,y)
    else
        []

--Drive function to generate list of bools for each square, starting at square (x,y)
squaresValid : Matrix Int -> Int -> Int -> List Bool
squaresValid m x y =
    if y < 9 then
        if x < 6 then
            [(validList (List.sort (squareDriver (m) 0 0 (y,x))))] ++ squaresValid m (x+3) y
        else
            [(validList (List.sort (squareDriver (m) 0 0 (y,x))))] ++ squaresValid m 0 (y+3)
    else
        []
---------------------------------------------------------------------------------------------------


--Column validation methods
---------------------------------------------------------------------------------------------------
--Helper function to generate list from matrix column j
columnDriver : Matrix Int -> Int -> Int -> List Int
columnDriver m i j =
    if i < 9 then
        [Maybe.withDefault -1 (get(loc i j) m)] ++ columnDriver m (i+1) j
    else
        []

--Driver function to generate list of bools for each column, starting at column j        
columnsValid : Matrix Int -> Int -> List Bool
columnsValid m j =
    if j < 9 then
        [(validList (List.sort (columnDriver (m) 0 j)))] ++ columnsValid m (j+1)
    else
        []
---------------------------------------------------------------------------------------------------



--Row validation methods
---------------------------------------------------------------------------------------------------

--Helper function to sort a list (row) at index i from overall list of rows    
rowDriver : List (List Int) -> Int -> List Int
rowDriver m i =
    List.sort (Maybe.withDefault [] (getAt m i))


--Driver function to generate list of bools for each row, starting at row i
rowsValid : Matrix Int -> Int -> List Bool
rowsValid m i =
    if i < 9 then
        [(validList (rowDriver (Matrix.toList m) i))] ++ rowsValid m (i+1)
    else
        []

-------------------------------------------------------------------------------------------------------

--Helper function to traverse matrix and wrap each element in an SVG message

rowsToSvg : Matrix Tile -> Int -> Int -> List (Svg Msg)
rowsToSvg m x_acc y_acc =
    if x_acc < 9 then
        let (x_coord, y_coord) = (((toFloat x_acc)*11.11+3.85),((toFloat y_acc)*11+9)) in
        case Maybe.withDefault Blank (get (loc y_acc x_acc) m) of
            Blank -> (svg [] [ text_ [x (toString x_coord), y (toString y_coord), fontSize "8"] [Svg.text " "] ])::(rowsToSvg m (x_acc+1) (y_acc))
            T val -> (svg [] [ text_ [x (toString x_coord), y (toString y_coord), fontSize "8"] [Svg.text (toString val)] ])::(rowsToSvg m (x_acc+1) (y_acc))
            P val -> (svg [] [ text_ [x (toString x_coord), y (toString y_coord), fontSize "8", fill "blue"] [Svg.text (toString val)] ])::(rowsToSvg m (x_acc+1) (y_acc))
    else if y_acc < 9 then
        let (x_coord, y_coord) = (((toFloat x_acc)*11.11+3.85),((toFloat y_acc)*11+9)) in
        case Maybe.withDefault Blank (get (loc y_acc x_acc) m) of
            Blank -> (svg [] [ text_ [x (toString x_coord), y (toString y_coord), fontSize "8"] [Svg.text " "] ])::(rowsToSvg m (0) (y_acc+1))
            T val -> (svg [] [ text_ [x (toString x_coord), y (toString y_coord), fontSize "8"] [Svg.text (toString val)] ])::(rowsToSvg m (0) (y_acc+1))
            P val -> (svg [] [ text_ [x (toString x_coord), y (toString y_coord), fontSize "8", fill "blue"] [Svg.text (toString val)] ])::(rowsToSvg m (0) (y_acc+1))
    else
        []

--Calls rowsToSVG and wraps its return value in an SVG message

matrixToSvg : Model -> Svg Msg
matrixToSvg model =
    svg
        [] 
        (rowsToSvg model.board 0 0)


toIntegerMatrix : Matrix Tile -> Matrix Int
toIntegerMatrix m = 
    Matrix.map tileToInt m

-- used for board validation
tileToInt : Tile -> Int
tileToInt t =
    case t of
        Blank -> -1
        T val -> val
        P val -> val

-- Used for SVG text of numbers on the board
tileToVal : Tile -> String
tileToVal t =
    case t of
        Blank -> " "
        T val -> toString val
        P val -> toString val

-- used to create the matrix from the makeBoard list
tupleToTile : (Int,Bool) -> Tile
tupleToTile (val,mutable) =
    if val == -1 then
        Blank
    else
        if mutable == True then
            T val
        else
            P val



makeBoard : List (List (Int, Bool)) --(value,mutable?), if value is -1, will be blank when displayed
makeBoard =
    [[(4,True),(3,True),(5,True),(2,True),(6,True),(9,False),(7,True),(8,True),(1,True)], 
    [(6,True),(8,True),(-1,True),(5,True),(7,True),(1,True),(-1,True),(9,True),(3,True)],
    [(1,True),(9,True),(7,True),(8,True),(3,True),(4,True),(5,True),(6,True),(2,True)],
    [(8,True),(2,True),(6,True),(1,True),(-1,True),(5,True),(3,True),(4,True),(7,True)],
    [(3,True),(7,True),(4,True),(6,True),(8,True),(2,True),(9,True),(1,True),(5,True)], 
    [(9,True),(5,True),(1,True),(7,True),(4,True),(3,True),(6,True),(2,True),(8,True)],
    [(5,True),(1,True),(9,True),(3,True),(2,True),(6,True),(8,True),(7,True),(4,True)], 
    [(2,True),(4,True),(8,True),(9,True),(5,True),(7,True),(1,True),(-1,True),(6,True)], 
    [(7,True),(6,True),(3,True),(4,True),(1,True),(8,True),(2,True),(5,True),(9,True)]]

updateBoard : Matrix Tile -> Int -> Int -> Int -> Matrix Tile
updateBoard m v y x =
    if v /= 0 then
        case (Maybe.withDefault Blank (get (loc (x-1) (y-1)) m)) of
            Blank -> Matrix.set (loc (x-1) (y-1)) (T v) m
            T _ -> Matrix.set (loc (x-1) (y-1)) (T v) m
            P _ -> m
    else
        case (Maybe.withDefault Blank (get (loc (x-1) (y-1)) m)) of
            P _ -> m
            _ -> Matrix.set (loc (x-1) (y-1)) Blank m

{-subscriptions : Model -> Sub Msg
subscriptions model =
  Debug.crash "ghello"-}

inputValidate : String -> Int
inputValidate s =
    let num = (Result.withDefault 0 (String.toInt s)) in
        if num < 0 then
            0
        else if num > 9 then
            0
        else if (isNaN (toFloat num)) then
            0
        else
            num

update : Msg -> Model -> Model--(Model, Cmd Msg)
update msg model =
  case msg of
    ValInput val ->
        { model | input = inputValidate val }
    XInput x ->
        { model | inputX = inputValidate x }
    YInput y ->
        { model | inputY = inputValidate y }
    UpdateBoard ->
        let newMatrix = updateBoard model.board model.input model.inputX model.inputY in
        { model | board = newMatrix }
    ValidateBoard ->
        { model | isValid = checkList (sudokuValidation model 0) }
    Reset ->
        initialModel

viewVal : Model -> Html Msg
viewVal model =
    if model.isValid then
        Html.text (String.concat [(toString model.input)," ",(toString model.inputX), " ", (toString model.inputY),"Congrats, solution found"])
    else
        Html.text (String.concat [(toString model.input)," ",(toString model.inputX), " ", (toString model.inputY),"Unsolved"])

view : Model -> Html Msg
view model =
  div []
  [
        Html.text "Sudoku",
      svg
        [ viewBox "-100 -20 200 150", width "1000px", fontFamily "trebuchet" ] (List.append [ rect [ x "0", y "0", width "100", Svg.Attributes.height "100", fill "none", stroke "black" ] [],
            line [ x1 "0", y1 "11.111", x2 "100", y2 "11.111", stroke "black", strokeWidth ".5" ] [],
            line [ x1 "0", y1 "22.222", x2 "100", y2 "22.222", stroke "black", strokeWidth ".5" ] [],
            line [ x1 "0", y1 "33.333", x2 "100", y2 "33.333", stroke "black" ] [], --h quadrant
            line [ x1 "0", y1 "44.444", x2 "100", y2 "44.444", stroke "black", strokeWidth ".5" ] [],
            line [ x1 "0", y1 "55.555", x2 "100", y2 "55.555", stroke "black", strokeWidth ".5" ] [],
            line [ x1 "0", y1 "66.666", x2 "100", y2 "66.666", stroke "black" ] [], --h quadrant
            line [ x1 "0", y1 "77.777", x2 "100", y2 "77.777", stroke "black", strokeWidth ".5" ] [],
            line [ x1 "0", y1 "88.888", x2 "100", y2 "88.888", stroke "black", strokeWidth ".5" ] [], 
            line [ x1 "0", y1 "99.999", x2 "100", y2 "99.999", stroke "black", strokeWidth ".5" ] [], 
            line [ x1 "11.111", y1 "0", x2 "11.111", y2 "100", stroke "black", strokeWidth ".5" ] [],
            line [ x1 "22.222", y1 "0", x2 "22.222", y2 "100", stroke "black", strokeWidth ".5" ] [],
            line [ x1 "33.333", y1 "0", x2 "33.333", y2 "100", stroke "black" ] [], --v quadrant
            line [ x1 "44.444", y1 "0", x2 "44.444", y2 "100", stroke "black", strokeWidth ".5" ] [],
            line [ x1 "55.555", y1 "0", x2 "55.555", y2 "100", stroke "black", strokeWidth ".5" ] [],
            line [ x1 "66.666", y1 "0", x2 "66.666", y2 "100", stroke "black" ] [], --v quadrant
            line [ x1 "77.777", y1 "0", x2 "77.777", y2 "100", stroke "black", strokeWidth ".5" ] [],
            line [ x1 "88.888", y1 "0", x2 "88.888", y2 "100", stroke "black", strokeWidth ".5" ] [],
            line [ x1 "99.999", y1 "0", x2 "99.999", y2 "100", stroke "black" ] [],
            --X COORDS
            text_ [x "3.8555", y "106", fontSize "6", fill "red"] [Svg.text (toString 1)],
            text_ [x "14.966722", y "106", fontSize "6", fill "red"] [Svg.text (toString 2)],
            text_ [x "26.07783333", y "106", fontSize "6", fill "red"] [Svg.text (toString 3)],
            text_ [x "37.188944", y "106", fontSize "6", fill "red"] [Svg.text (toString 4)],
            text_ [x "48.300055", y "106", fontSize "6", fill "red"] [Svg.text (toString 5)],
            text_ [x "59.41116", y "106", fontSize "6", fill "red"] [Svg.text (toString 6)],
            text_ [x "70.52227", y "106", fontSize "6", fill "red"] [Svg.text (toString 7)],
            text_ [x "81.63338", y "106", fontSize "6", fill "red"] [Svg.text (toString 8)],
            text_ [x "92.7445", y "106", fontSize "6", fill "red"] [Svg.text (toString 9)],
            --Y COORDS
            text_ [x "-6", y "8", fontSize "6", fill "red"] [Svg.text (toString 1)],
            text_ [x "-6", y "19", fontSize "6", fill "red"] [Svg.text (toString 2)],
            text_ [x "-6", y "30", fontSize "6", fill "red"] [Svg.text (toString 3)],
            text_ [x "-6", y "41", fontSize "6", fill "red"] [Svg.text (toString 4)],
            text_ [x "-6", y "52", fontSize "6", fill "red"] [Svg.text (toString 5)],
            text_ [x "-6", y "63", fontSize "6", fill "red"] [Svg.text (toString 6)],
            text_ [x "-6", y "74", fontSize "6", fill "red"] [Svg.text (toString 7)],
            text_ [x "-6", y "85", fontSize "6", fill "red"] [Svg.text (toString 8)],
            text_ [x "-6", y "96", fontSize "6", fill "red"] [Svg.text (toString 9)]
            --foreignObject [x "10", y "110", name "input", fontSize "5", width "2", height "2"] [ input [type_ "text", size 1] [] ]


            --input [ type_ "text", placeholder "what" ] []




         ] [(matrixToSvg model)]),
        input [ type_ "text", size 1, onInput ValInput ] [],
        input [ type_ "text", size 1, onInput XInput ] [],
        input [ type_ "text", size 1, onInput YInput ] [],
        button [onClick UpdateBoard] [ Html.text "Submit" ],
        button [onClick ValidateBoard] [ Html.text "Check Board" ],
        button [onClick Reset] [ Html.text "Restart" ],
        viewVal model
    ]
    --input [type_ "text", size 1] []