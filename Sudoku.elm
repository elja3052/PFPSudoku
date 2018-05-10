<<<<<<< HEAD
<<<<<<< HEAD

-- Matthew Menten & Eli Jacobshagen
-- Principles of Functional Programming - Hammer - CU Boulder S18
-- 5/9/2018

=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
module Sudoku exposing (main
    , initialModel
    , init
    , matrixToSvg
<<<<<<< HEAD
<<<<<<< HEAD
=======
    , makeBoard
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
    , makeBoard
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
    , sudokuValidation
    , checkList
    )


import Matrix exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
<<<<<<< HEAD
<<<<<<< HEAD
import Html exposing (..)
import Html.Attributes exposing (placeholder,size,form)
import Html.Events exposing (..)
import Json.Decode as Json exposing (..)
import VirtualDom
import Mouse exposing (Position)
import Boards exposing (..)
import Random exposing (Generator, Seed)
import Time

-- beginner program does not need subscriptions function
=======
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
import Time exposing (..)
import Html exposing (..)
import Html.Attributes exposing (placeholder,size,form)
import Html.Events exposing (..)


<<<<<<< HEAD
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
main : Program Never Model Msg
main = 
  Html.beginnerProgram
    { model = initialModel
    , view = view
    , update = update
    }

type alias Model =
<<<<<<< HEAD
<<<<<<< HEAD
  { board : Matrix Tile,  -- sudoku board
    input : Int,          -- User input from form
    isValid : Bool,       -- is the board solved or not
    clickCoord : Position,-- board coords converted from mouse clicks
    seed : Seed,
    curBoard : Int
  }


type Tile = Blank -- Blank tile
    | T Int       -- Mutable tile
    | P Int       -- Persistant tile, val cannot be changed by user

type Msg = 
    ValInput String -- Tile number from form
    | UpdateBoard   -- Adds user changes to board
    | ValidateBoard
    | Reset
    | Clicked Position
    | ChangeBoard

=======
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
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
    ValInput String -- Tile number from form
    | XInput String -- x coord from form
    | YInput String -- y
    | UpdateBoard   -- Adds user changes to board
    | ValidateBoard
    | Reset
<<<<<<< HEAD
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a

init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)

<<<<<<< HEAD
<<<<<<< HEAD
-- initializes board from boards file
initialModel : Model
initialModel =
  { board = Matrix.map tupleToTile (Matrix.fromList Boards.easyBoard1),
    input = -1,
    isValid = False,
    clickCoord = {x = -1, y = -1},
    seed = (Random.initialSeed 1235453), -- change to time?
    curBoard = 1
=======
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
initialModel : Model
initialModel =
  { board = Matrix.map tupleToTile (Matrix.fromList makeBoard),
    input = -1,
    inputX = -1,
    inputY = -1,
    isValid = False
<<<<<<< HEAD
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
  }


--Helper functions
-----------------------------------------------------------------

--Comparable list containing 1-9 in ascending order
<<<<<<< HEAD
<<<<<<< HEAD
-- used for board validation
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
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


-------------------------------------------------------------------
-- Validation Functions


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

<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
-------------------------------------------------------------------------------------------------------
-- Initial Board

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

<<<<<<< HEAD
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a

-------------------------------------------------------------------------------------------------------
-- Update functions


<<<<<<< HEAD
<<<<<<< HEAD
-- checks bounds on click; only updates if within board
posToCoords : Model -> Position -> Position
posToCoords model pos =
    if pos.x > 480 && pos.x < 965 && pos.y > 141 && pos.y < 630 then
        {x = xRanges pos.x, y = yRanges pos.y}
    else
        model.clickCoord

-- determine x coord of tile based on click
xRanges : Int -> Int
xRanges x =
    if x > 483 && x < 535 then 1
    else if x > 536 && x < 588 then 2
    else if x > 589 && x < 641 then 3
    else if x > 644 && x < 695 then 4
    else if x > 697 && x < 749 then 5
    else if x > 750 && x < 801 then 6
    else if x > 805 && x < 856 then 7
    else if x > 857 && x < 910 then 8
    else if x > 911 && x < 962 then 9
    else -1

-- determine y coord of tile based on click
yRanges : Int -> Int
yRanges y =
    if y > 146 && y < 197 then 1
    else if y > 198 && y < 251 then 2
    else if y > 252 && y < 303 then 3
    else if y > 306 && y < 358 then 4
    else if y > 359 && y < 411 then 5
    else if y > 411 && y < 464 then 6
    else if y > 467 && y < 518 then 7
    else if y > 519 && y < 572 then 8
    else if y > 573 && y < 624 then 9
    else -1

=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
-- converts string from form input into int
inputValidate : String -> Int
inputValidate s =
    let num = (Result.withDefault 0 (String.toInt s)) in
        if num < 0 then
            0
        else if num > 9 then
            0
        else if (isNaN (toFloat num)) then  -- int type does not have isNaN function smh
<<<<<<< HEAD
<<<<<<< HEAD
            0                               -- handles errors from characters like +,- in the form
=======
            0
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
            0
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
        else
            num

-- updates board with user input from form
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


<<<<<<< HEAD
<<<<<<< HEAD
-- ensures new board is not the same as current board
getNewRand : Model -> (Int,Seed)
getNewRand model =
    let (rand,s) = Random.step (Random.int 1 3) model.seed in
    if rand == model.curBoard then
        getNewRand { model | seed = s }
    else
        (rand,s)


-- handles messages from form and buttons
update : Msg -> Model -> Model
=======
-- handles form messages
update : Msg -> Model -> Model--(Model, Cmd Msg)
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
-- handles form messages
update : Msg -> Model -> Model--(Model, Cmd Msg)
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
update msg model =
  case msg of
    ValInput val ->
        { model | input = inputValidate val }
<<<<<<< HEAD
<<<<<<< HEAD
    UpdateBoard ->
        let newMatrix = updateBoard model.board model.input model.clickCoord.x model.clickCoord.y in
=======
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
    XInput x ->
        { model | inputX = inputValidate x }
    YInput y ->
        { model | inputY = inputValidate y }
    UpdateBoard ->
        let newMatrix = updateBoard model.board model.input model.inputX model.inputY in
<<<<<<< HEAD
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
        { model | board = newMatrix }
    ValidateBoard ->
        { model | isValid = checkList (sudokuValidation model 0) }
    Reset ->
<<<<<<< HEAD
<<<<<<< HEAD
        let bd =
            if model.curBoard == 1 then Boards.easyBoard1
            else if model.curBoard == 2 then Boards.easyBoard2
            else Boards.hardBoard1
        in
        { model | isValid = False, board = Matrix.map tupleToTile (Matrix.fromList bd) }
    Clicked position ->
        { model | clickCoord = (posToCoords model position) } -- translates mouse coords into board coords b4 updating model
    ChangeBoard ->
        let (rand,s) = getNewRand model in
        case rand of
            1 ->
                {board = Matrix.map tupleToTile (Matrix.fromList Boards.easyBoard1), 
                input = model.input, isValid = model.isValid, clickCoord = model.clickCoord, seed = s, curBoard = 1 }
            2 ->
                {board = Matrix.map tupleToTile (Matrix.fromList Boards.easyBoard2), 
                input = model.input, isValid = model.isValid, clickCoord = model.clickCoord, seed = s, curBoard = 2 }
            3 ->
                {board = Matrix.map tupleToTile (Matrix.fromList Boards.hardBoard1), 
                input = model.input, isValid = model.isValid, clickCoord = model.clickCoord, seed = s, curBoard = 3 }
            _ -> Debug.crash "In update -- change board random number out of bounds"


-- next four functions are for handling mouse click events\
-- uses HTML DOM and JSON magic
-- cargo culted from https://stackoverflow.com/questions/40269494/
-- NOTE: this was used instead of HTML onClick event b/c it wouldn't get coords inside the SVG viewbox
onClickLocation : Html.Attribute Msg
onClickLocation =
    mouseClick Clicked


offsetPosition : Json.Decoder Position
offsetPosition =
    Json.map2 Position (field "pageX" Json.int) (field "pageY" Json.int)


mouseEvent : String -> (Position -> msg) -> VirtualDom.Property msg
mouseEvent event messager =
    let
        options =
            { preventDefault = True, stopPropagation = True }
    in
        VirtualDom.onWithOptions event options (Json.map messager offsetPosition)


mouseClick : (Position -> msg) -> VirtualDom.Property msg
mouseClick =
    mouseEvent "click"
=======
        initialModel
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
        initialModel
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a

-------------------------------------------------------------------------------------------------------
-- View Functions


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

<<<<<<< HEAD
<<<<<<< HEAD

{-   NO LONGER USED IN CURRENT VERSION
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
-- outputs values from model next to forms
viewVal : Model -> Html Msg
viewVal model =
    if model.isValid then
<<<<<<< HEAD
<<<<<<< HEAD
        Html.text (String.concat [(toString model.input)," ",(toString model.clickCoord.x), " ", (toString model.clickCoord.y)," Congrats, solution found!"])
    else
        Html.text (String.concat [(toString model.input)," ",(toString model.clickCoord.x), " ", (toString model.clickCoord.y)," Unsolved"])
-}
=======
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
        Html.text (String.concat [(toString model.input)," ",(toString model.inputX), " ", (toString model.inputY),"Congrats, solution found"])
    else
        Html.text (String.concat [(toString model.input)," ",(toString model.inputX), " ", (toString model.inputY),"Unsolved"])

<<<<<<< HEAD
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a


view : Model -> Html Msg
view model =
<<<<<<< HEAD
<<<<<<< HEAD
    let (isSolved,tColor) =
        if model.isValid then ("Solved","green")
        else ("Unsolved","red")
    in
    let (strX,strY) = 
        (toString model.clickCoord.x, toString model.clickCoord.y)
    in
  div [ onClickLocation ]
    [

      svg
        [ viewBox "-100 -30 280 155", width "1350px", fontFamily "impact" ] 
        (List.append [ rect [ x "0", y "0", width "100", Svg.Attributes.height "100", fill "none", stroke "black" ] [],
=======
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
  div []
  [
        Html.text "Sudoku",
      svg
        [ viewBox "-100 -20 205 150", width "1000px", fontFamily "trebuchet" ] (List.append [ rect [ x "0", y "0", width "100", Svg.Attributes.height "100", fill "none", stroke "black" ] [],
<<<<<<< HEAD
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
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
<<<<<<< HEAD
<<<<<<< HEAD
            text_ [x "-6", y "96", fontSize "6", fill "red"] [Svg.text (toString 9)],
            foreignObject [x "25", y "-20"] [ Html.text "Sudoku" ],
            foreignObject [x "-77", y "40"] [ input [ type_ "text", size 1, onInput ValInput ] [] ],
            foreignObject [x "-85", y "65"] [ button [Html.Events.onClick UpdateBoard] [ Html.text "Submit" ] ],
            foreignObject [x "120", y "25"] [ button [Html.Events.onClick ValidateBoard] [ Html.text "Check Board" ] ],
            foreignObject [x "120", y "-25"] [ button [Html.Events.onClick ChangeBoard] [ Html.text "New Puzzle" ] ],
            foreignObject [x "120", y "70"] [ button [Html.Events.onClick Reset] [ Html.text "Restart" ] ],
            text_ [x "25", y "122", fontSize "13", fill tColor] [Svg.text isSolved],
            text_ [x "-90", y "0", fontSize "8"] [Svg.text "Selected Coordinates:"],
            text_ [x "-70", y "15", fontSize "10", fill "red"] [Svg.text (String.concat [strX, " , ",strY]) ]


         ] [(matrixToSvg model)])
    ]
=======
=======
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
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
<<<<<<< HEAD
    --input [type_ "text", size 1] []
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
=======
    --input [type_ "text", size 1] []
>>>>>>> d37b2ac4e6b0b090dd91714298e6cfec8e23ab2a
