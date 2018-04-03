module Sudoku exposing (main
    , initialModel
    , init
    , matrixToSVG
    , makeBoard
    , sudokuValidation
    , checkList
    )


import Matrix exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (..)
import Html exposing (..)
--import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program Never Model Msg
main = 
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


type alias Coord = 
    {x : Float, y : Float}

type alias Model =
  { board : Matrix Tile,
    input : String
  }

type Tile = Blank --Blank tile
    | T Int --Mutable tile
    | P Int --Persistant tile, val cannot be changed by user

type Msg = 
    Tick Time.Time
    | Input String

init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)

initialModel : Model
initialModel =
  { board = Matrix.map tupleToTile (Matrix.fromList makeBoard),
    input = ""
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



matrixToSVG : Matrix Tile -> Svg Msg
matrixToSVG m =
    svg
        [] 
        [ text_ [x "3.8555", y "9.111", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 0 0) m)))],
        text_ [x "14.966722", y "9.111", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 0 1) m)))],
        text_ [x "26.07783333", y "9.111", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 0 2) m)))],
        text_ [x "37.188944", y "9.111", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 0 3) m)))],
        text_ [x "48.300055", y "9.111", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 0 4) m)))],
        text_ [x "59.41116", y "9.111", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 0 5) m)))],
        text_ [x "70.52227", y "9.111", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 0 6) m)))],
        text_ [x "81.63338", y "9.111", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 0 7) m)))],
        text_ [x "92.7445", y "9.111", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 0 8) m)))],
        --END ROW 1
        text_ [x "3.8555", y "19.5", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 1 0) m)))],
        text_ [x "14.966722", y "19.5", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 1 1) m)))],
        text_ [x "26.07783333", y "19.5", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 1 2) m)))],
        text_ [x "37.188944", y "19.5", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 1 3) m)))],
        text_ [x "48.300055", y "19.5", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 1 4) m)))],
        text_ [x "59.41116", y "19.5", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 1 5) m)))],
        text_ [x "70.52227", y "19.5", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 1 6) m)))],
        text_ [x "81.63338", y "19.5", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 1 7) m)))],
        text_ [x "92.7445", y "19.5", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 1 8) m)))],
        --END ROW 2
        text_ [x "3.8555", y "30.25", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 2 0) m)))],
        text_ [x "14.966722", y "30.25", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 2 1) m)))],
        text_ [x "26.07783333", y "30.25", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 2 2) m)))],
        text_ [x "37.188944", y "30.25", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 2 3) m)))],
        text_ [x "48.300055", y "30.25", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 2 4) m)))],
        text_ [x "59.41116", y "30.25", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 2 5) m)))],
        text_ [x "70.52227", y "30.25", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 2 6) m)))],
        text_ [x "81.63338", y "30.25", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 2 7) m)))],
        text_ [x "92.7445", y "30.25", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 2 8) m)))],
        --END ROW 3
        text_ [x "3.8555", y "41.8", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 3 0) m)))],
        text_ [x "14.966722", y "41.8", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 3 1) m)))],
        text_ [x "26.07783333", y "41.8", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 3 2) m)))],
        text_ [x "37.188944", y "41.8", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 3 3) m)))],
        text_ [x "48.300055", y "41.8", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 3 4) m)))],
        text_ [x "59.41116", y "41.8", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 3 5) m)))],
        text_ [x "70.52227", y "41.8", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 3 6) m)))],
        text_ [x "81.63338", y "41.8", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 3 7) m)))],
        text_ [x "92.7445", y "41.8", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 3 8) m)))],
        --END ROW 4
        text_ [x "3.8555", y "52.9", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 4 0) m)))],
        text_ [x "14.966722", y "52.9", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 4 1) m)))],
        text_ [x "26.07783333", y "52.9", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 4 2) m)))],
        text_ [x "37.188944", y "52.9", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 4 3) m)))],
        text_ [x "48.300055", y "52.9", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 4 4) m)))],
        text_ [x "59.41116", y "52.9", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 4 5) m)))],
        text_ [x "70.52227", y "52.9", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 4 6) m)))],
        text_ [x "81.63338", y "52.9", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 4 7) m)))],
        text_ [x "92.7445", y "52.9", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 4 8) m)))],
         --END ROW 5
        text_ [x "3.8555", y "64", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 5 0) m)))],
        text_ [x "14.966722", y "64", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 5 1) m)))],
        text_ [x "26.07783333", y "64", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 5 2) m)))],
        text_ [x "37.188944", y "64", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 5 3) m)))],
        text_ [x "48.300055", y "64", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 5 4) m)))],
        text_ [x "59.41116", y "64", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 5 5) m)))],
        text_ [x "70.52227", y "64", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 5 6) m)))],
        text_ [x "81.63338", y "64", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 5 7) m)))],
        text_ [x "92.7445", y "64", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 5 8) m)))],
        --END ROW 6
        text_ [x "3.8555", y "75.1", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 6 0) m)))],
        text_ [x "14.966722", y "75.1", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 6 1) m)))],
        text_ [x "26.07783333", y "75.1", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 6 2) m)))],
        text_ [x "37.188944", y "75.1", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 6 3) m)))],
        text_ [x "48.300055", y "75.1", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 6 4) m)))],
        text_ [x "59.41116", y "75.1", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 6 5) m)))],
        text_ [x "70.52227", y "75.1", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 6 6) m)))],
        text_ [x "81.63338", y "75.1", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 6 7) m)))],
        text_ [x "92.7445", y "75.1", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 6 8) m)))],
        --END ROW 7
        text_ [x "3.8555", y "86.2", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 7 0) m)))],
        text_ [x "14.966722", y "86.2", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 7 1) m)))],
        text_ [x "26.07783333", y "86.2", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 7 2) m)))],
        text_ [x "37.188944", y "86.2", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 7 3) m)))],
        text_ [x "48.300055", y "86.2", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 7 4) m)))],
        text_ [x "59.41116", y "86.2", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 7 5) m)))],
        text_ [x "70.52227", y "86.2", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 7 6) m)))],
        text_ [x "81.63338", y "86.2", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 7 7) m)))],
        text_ [x "92.7445", y "86.2", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 7 8) m)))],
        --END ROW 8
        text_ [x "3.8555", y "97.3", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 8 0) m)))],
        text_ [x "14.966722", y "97.3", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 8 1) m)))],
        text_ [x "26.07783333", y "97.3", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 8 2) m)))],
        text_ [x "37.188944", y "97.3", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 8 3) m)))],
        text_ [x "48.300055", y "97.3", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 8 4) m)))],
        text_ [x "59.41116", y "97.3", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 8 5) m)))],
        text_ [x "70.52227", y "97.3", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 8 6) m)))],
        text_ [x "81.63338", y "97.3", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 8 7) m)))],
        text_ [x "92.7445", y "97.3", fontSize "8"] [Svg.text (tileToVal (Maybe.withDefault Blank (get(loc 8 8) m)))]
        ]

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
    [(6,True),(8,True),(2,True),(5,True),(7,True),(1,True),(4,True),(9,True),(3,True)],
    [(1,True),(9,True),(7,True),(8,True),(3,True),(4,True),(5,True),(6,True),(2,True)],
    [(8,True),(2,True),(6,True),(1,True),(9,True),(5,True),(3,True),(4,True),(7,True)],
    [(3,True),(7,True),(4,True),(6,True),(8,True),(2,True),(9,True),(1,True),(5,True)], 
    [(9,True),(5,True),(1,True),(7,True),(4,True),(3,True),(6,True),(2,True),(8,True)],
    [(5,True),(1,True),(9,True),(3,True),(2,True),(6,True),(8,True),(7,True),(4,True)], 
    [(2,True),(4,True),(8,True),(9,True),(5,True),(7,True),(1,True),(3,True),(6,True)], 
    [(7,True),(6,True),(3,True),(4,True),(1,True),(8,True),(2,True),(5,True),(9,True)]]

subscriptions : Model -> Sub Msg
subscriptions model =
  Debug.crash "ghello"


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  Debug.crash "nun"

view : Model -> Html Msg
view model =
  div []
  [
      svg
        [ viewBox "-100 -20 200 200", width "1000px" ] (List.append [ rect [ x "0", y "0", width "100", height "100", fill "none", stroke "black" ] [],
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



            --input [ type_ "text", placeholder "what" ] []




         ] [(matrixToSVG model.board)])
        --div [] [ input ["yuhh"] ]
    ]