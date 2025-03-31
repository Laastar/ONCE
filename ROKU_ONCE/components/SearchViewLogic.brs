function ShowSearchView()
    searchView = CreateObject("roSGNode", "SearchView")
    searchView.hintText = "Enter search term"
    ' query field will be changed each time user has typed something
    searchView.ObserveField("query", "OnSearchQuery")
    searchView.ObserveField("rowItemSelected", "OnSearchItemSelected")

    ' This will cause the View to be shown on the View
    m.top.ComponentController.callFunc("show", {
        view: searchView
    })
    return searchView
end function

sub OnSearchQuery(event as Object)
    print "realizado busqeuda"
    query = event.GetData()
    searchView = event.GetRoSGNode()

    content = CreateObject("roSGNode", "ContentNode")
    'if query.Len() > 2 ' perform search if user has typed at least three characters
    content.AddFields({
        HandlerConfigSearch: {
            name: "SearchHandler"
            fields : {query: query}
            'query: query ' pass the query to the content handler
        }
    })
    'end if
    
    ' setting the content with handlerConfigSearch will create
    ' the content handler where search should be performed
    ' setting the clear content node or invalid will clear the grid with results
    searchView.content = content
end sub

sub OnSearchItemSelected(event as Object)
    ? "Item selected = " ; event.GetData()
end sub
