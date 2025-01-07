# julio_tobares_ios_challenge

iOS Challenge

For this challenge, the project structure follows the MVVM pattern and was divided in Core and Presentation folders.

For Presentation, following the wireframes i've created a HomeView as container of two custom views for portrait and landscape mode, in HomeView just validating orientation.
    Inside each custom view, appears an stack as a navigation bar with a button to show/hide favorites and a search bar to filter cities. 
    Below a list that show an stack with a navigation view in portrait for listView -> MapView and a stack with the two items in lanscapemode. 
    
    The MapView works as a dummy view just showing the landmark when is tapped in the list.
    The search bar is binded to a published property in the ListViewModel, so create new requests to core data
    The Managed object context is injected in the viewModel when app starts.
    The viewModel is instantiated as EnvironmentObject to use it from all the UI layers.
    
For Core module, the project contains Managers and Models, for persistance and filtering purpouses the project use Core Data. I chooed this solution because the optimization of filtering an array of +200k cities was the goal of the challenge. For core data was added some entities and added functions to create, read and update entities in the CoreDataManager class.
    1st reason: the attibute "name" was setted as indexed it enhance the filtering process
    2nd reason: when add new items to the database, it's possible to save as a batch, not one by one
    3rd reason: it's possible to request using NSPredicate or complex predicates
    4rd reason: It's possible to handle the max limit of entities per request using request.fetchLimit, that's improve the memory usage
    5th reason: Adding a new attribute to each city, since is only one user it was simple to filter the favorites between app restarts.
    6th reason: It's possible to handle pagination, using the attribute request.offset, to avoid overload the main thread with all the data. (Not implemented)

Unit test added covering two success cases.
