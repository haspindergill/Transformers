# Transformers

### Appoach
Initally we assume there is no auth token in keychain, therefore we add startViewController where we check for auth token in keychain if token == nil, call https://transformers-api.firebaseapp.com/allspark and store auth token in keychain for next use. At listViewController meanwhile we are fetching list of transformers from https://transformers-api.firebaseapp.com/transformers , display cache list means diplay a list of transformers from core data (internal database)


#### List Functionality:
ListViewController list all the transformers into list.
 
#### Create Functionality:
Click "+" button in upper navigation to add new transformer

#### Delete Functionality:
Swipe to left to delete any transformer

#### Edit Functionality:
Click any transformer into list
