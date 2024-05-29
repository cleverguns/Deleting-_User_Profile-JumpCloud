# Input Validation Appsheet Cheat sheet


1. Cost input validation in travel PR 
if valid Code sample in departure_checked_bag_fee:  

## Valid_If: Ensures that the input is not negative.

[departure_checked_bag_fee] >= 0


## Error_Message_If_Invalid: Provides a custom error message when the input is negative.

"Departure Fee cannot be negative"


2. QTY

## Valid_If:

IFS([qty] < 0, "The quantity should be 1 or more only.")



3. departure_cost -Travel PR

## Valid_If:

[departure_cost] >= 0

## Error_Message_If_Invalid:

"Departure cost cannot be negative"



4. return_cost - Travel_PR : return_cost

## Valid_If:

[return_cost] >= 0

## Error_Message_If_Invalid:

"return cost cannot be negative"


4. return_checked_bag_fee - Travel_PR : return_cost

## Valid_If:

[return_checked_bag_fee] >= 0

## Error_Message_If_Invalid:

"return bag fee cannot be negative"




5. Valid If formula for column meal_allowance - Travel_PR : return_cost

## Valid_If:

[meal_allowance] >= 0

## Error_Message_If_Invalid:

"cannot be negative"



6. Valid If formula for column transportation_allowance - Travel_PR : return_cost


## Valid_If:

[transportation_allowance] >= 0
## Error_Message_If_Invalid:

"cannot be negative" 





7. other_travel_expenses - Travel_PR : return_cost


## Valid_If:

[other_travel_expenses] >= 0
## Error_Message_If_Invalid:

"cannot be negative"


8.  Travel_PR : active_contact_number

## Valid_If:


## Error_Message_If_Invalid:

9.  

## Valid_If:
LEN(CONCATENATE([active_contact_number])) = 11

## Error_Message_If_Invalid:
number must be 11 digits


## note that we can combine all the conditions into a single Valid If expression for the in AppSheet

## all test are done in Staging 1.1
URL: https://www.appsheet.com/template/AppDef?appName=ProcureNetStaging-565838469&appId=bfb3b3b2-5ed5-4dfa-aba7-36510bb9f187&quickStart=False#Data.Columns.Travel_PR_Schema.Attributes.30