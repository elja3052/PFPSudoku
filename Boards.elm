module Boards exposing (..)

easyBoard1 : List (List (Int, Bool)) --(value,mutable?), if value is -1, will be blank when displayed
easyBoard1 =
    [[(4,True),(3,True),(5,True),(2,False),(6,False),(9,True),(7,False),(8,True),(1,False)], 
    [(6,False),(8,False),(-1,True),(5,True),(7,False),(1,True),(-1,True),(9,False),(3,True)],
    [(1,False),(9,False),(7,True),(8,True),(3,True),(4,False),(5,False),(6,True),(2,True)],
    [(8,False),(2,False),(6,True),(1,False),(-1,True),(5,True),(3,True),(4,False),(7,True)],
    [(3,True),(7,True),(4,False),(6,False),(8,True),(2,False),(9,False),(1,True),(5,True)], 
    [(9,True),(5,False),(1,True),(7,True),(4,True),(3,False),(6,True),(2,False),(8,False)],
    [(5,True),(1,True),(9,False),(3,False),(2,True),(6,True),(8,True),(7,False),(4,False)], 
    [(2,True),(4,False),(8,True),(9,True),(5,False),(7,True),(1,True),(3,False),(6,False)], 
    [(7,False),(6,True),(3,False),(4,True),(1,False),(8,False),(2,True),(5,True),(9,True)]]

{-easyBoard1Solved : List (List (Int, Bool)) --(value,mutable?), if value is -1, will be blank when displayed
easyBoard1Solved =
    [[(4,True),(3,True),(5,True),(2,False),(6,False),(9,True),(7,False),(8,True),(1,False)], 
    [(6,False),(8,False),(-1,True),(5,True),(7,False),(1,True),(-1,True),(9,False),(3,True)],
    [(1,False),(9,False),(7,True),(8,True),(3,True),(4,False),(5,False),(6,True),(2,True)],
    [(8,False),(2,False),(6,True),(1,False),(-1,True),(5,True),(3,True),(4,False),(7,True)],
    [(3,True),(7,True),(4,False),(6,False),(8,True),(2,False),(9,False),(1,True),(5,True)], 
    [(9,True),(5,False),(1,True),(7,True),(4,True),(3,False),(6,True),(2,False),(8,False)],
    [(5,True),(1,True),(9,False),(3,False),(2,True),(6,True),(8,True),(7,False),(4,False)], 
    [(2,True),(4,False),(8,True),(9,True),(5,False),(7,True),(1,True),(3,False),(6,False)], 
    [(7,False),(6,True),(3,False),(4,True),(1,False),(8,False),(2,True),(5,True),(9,True)]]-}

easyBoard2 : List (List (Int, Bool)) --(value,mutable?), if value is -1, will be blank when displayed
easyBoard2 =
    [[(1,True),(-1,True),(-1,True),(4,False),(8,False),(9,True),(-1,False),(-1,True),(6,False)], 
    [(7,False),(3,False),(-1,True),(-1,True),(5,False),(-1,True),(-1,True),(4,False),(-1,True)],
    [(4,False),(6,False),(-1,True),(-1,True),(-1,True),(1,False),(2,False),(9,True),(5,True)],
    [(3,False),(8,False),(7,True),(1,False),(2,True),(-1,True),(6,True),(-1,False),(-1,True)],
    [(5,True),(-1,True),(1,False),(7,False),(-1,True),(3,False),(-1,False),(-1,True),(8,True)], 
    [(-1,True),(4,False),(6,True),(-1,True),(9,True),(5,False),(7,True),(1,False),(-1,False)],
    [(9,True),(1,True),(4,False),(6,False),(-1,True),(-1,True),(-1,True),(8,False),(-1,False)], 
    [(-1,True),(2,False),(-1,True),(-1,True),(4,False),(-1,True),(-1,True),(3,False),(7,False)], 
    [(8,False),(-1,True),(3,False),(5,True),(1,False),(2,False),(-1,True),(-1,True),(4,True)]]

{-easyBoard2Solved : List (List (Int, Bool)) --(value,mutable?), if value is -1, will be blank when displayed
easyBoard2Solved =
    [[(1,True),(5,True),(2,True),(4,False),(8,False),(9,True),(3,False),(7,True),(6,False)], 
    [(7,False),(3,False),(9,True),(2,True),(5,False),(6,True),(8,True),(4,False),(1,True)],
    [(4,False),(6,False),(8,True),(3,True),(7,True),(1,False),(2,False),(9,True),(5,True)],
    [(3,False),(8,False),(7,True),(1,False),(2,True),(4,True),(6,True),(5,False),(9,True)],
    [(5,True),(9,True),(1,False),(7,False),(6,True),(3,False),(4,False),(2,True),(8,True)], 
    [(2,True),(4,False),(6,True),(8,True),(9,True),(5,False),(7,True),(1,False),(3,False)],
    [(9,True),(1,True),(4,False),(6,False),(3,True),(7,True),(5,True),(8,False),(2,False)], 
    [(6,True),(2,False),(5,True),(9,True),(4,False),(8,True),(1,True),(3,False),(7,False)], 
    [(8,False),(7,True),(3,False),(5,True),(1,False),(2,False),(9,True),(6,True),(4,True)]]-}

{-hardBoard1Solved : List (List (Int, Bool)) --(value,mutable?), if value is -1, will be blank when displayed
hardBoard1Solved =
    [[(1,True),(2,True),(6,True),(4,False),(3,False),(7,True),(9,False),(5,True),(8,False)], 
    [(8,False),(9,False),(5,True),(6,True),(2,False),(1,True),(4,True),(7,False),(3,True)],
    [(3,False),(7,False),(4,True),(9,True),(8,True),(5,False),(1,False),(2,True),(6,True)],
    [(4,False),(5,False),(7,True),(1,False),(9,True),(3,True),(8,True),(6,False),(2,True)],
    [(9,True),(8,True),(3,False),(2,False),(4,True),(6,False),(5,False),(1,True),(7,True)], 
    [(6,True),(1,False),(2,True),(5,True),(7,True),(8,False),(3,True),(9,False),(4,False)],
    [(2,True),(6,True),(9,False),(3,False),(1,True),(4,True),(7,True),(8,False),(5,False)], 
    [(5,True),(4,False),(8,True),(7,True),(6,False),(9,True),(2,True),(3,False),(1,False)], 
    [(7,False),(3,True),(1,False),(8,True),(5,False),(2,False),(6,True),(4,True),(9,True)]]-}

hardBoard1 : List (List (Int, Bool)) --(value,mutable?), if value is -1, will be blank when displayed
hardBoard1 =
    [[(-1,True),(2,True),(-1,True),(-1,False),(-1,False),(-1,True),(-1,False),(-1,True),(-1,False)], 
    [(-1,False),(-1,False),(-1,True),(6,True),(-1,False),(-1,True),(-1,True),(-1,False),(3,True)],
    [(-1,False),(7,False),(4,True),(-1,True),(8,True),(-1,False),(-1,False),(-1,True),(-1,True)],
    [(-1,False),(-1,False),(-1,True),(-1,False),(-1,True),(3,True),(-1,True),(-1,False),(2,True)],
    [(-1,True),(8,True),(-1,False),(-1,False),(4,True),(-1,False),(-1,False),(1,True),(-1,True)], 
    [(6,True),(-1,False),(-1,True),(5,True),(-1,True),(-1,False),(-1,True),(-1,False),(-1,False)],
    [(-1,True),(-1,True),(-1,False),(-1,False),(1,True),(-1,True),(7,True),(8,False),(-1,False)], 
    [(5,True),(-1,False),(-1,True),(-1,True),(-1,False),(9,True),(-1,True),(-1,False),(-1,False)], 
    [(-1,False),(-1,True),(-1,False),(-1,True),(-1,False),(-1,False),(-1,True),(4,True),(-1,True)]]