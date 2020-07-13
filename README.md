# Transformers

## Created without using a single third party library :muscle:

### Appoach
Initally we assume there is no auth token in keychain, therefore we add startViewController where we check for auth token in keychain if token == nil, call https://transformers-api.firebaseapp.com/allspark and store auth token in keychain for next use. At listViewController meanwhile we are fetching list of transformers from https://transformers-api.firebaseapp.com/transformers , display cache list means diplay a list of transformers from core data (internal database)


#### List Functionality:
ListViewController list all the transformers into list, it initially display results from internal database once we fetch list from firebase it replace internal list with firebase.
 
#### Create Functionality:
Click "+" button in upper navigation to add new transformer, it opens up view where we can set values and create a new transformer

#### Delete Functionality:
Swipe to left to delete any transformer, this action delete that particular from core data as well from firebase

#### Edit Functionality:
Click any transformer into list, it will took to view with prefilled values where we can change any value and update the transformer
