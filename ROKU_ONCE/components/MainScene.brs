' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

sub show(args as Object)
    showHomeView()
end sub

function showHomeView() as Object

    m.top.signalBeacon(“AppDialogInitiate”)
    
    ' Create an GridView object and assign some fields
    m.grid = CreateObject("roSGNode", "GridView")
    m.grid.setFields({
        style: "standard"
        posterShape: "16x9"
    })

    content = CreateObject("roSGNode", "ContentNode")
    ' This tells the GridView where to go to fetch the content
    content.addfields({
        HandlerConfigGrid: {
            name: "GridHandler"
        }
    })

    m.grid.content = content
    m.grid.ObserveField("rowItemSelected","OnGridItemSelected")
    ' This will run the content handler and show the Grid
    m.top.ComponentController.callFunc("show", {
        view: m.grid
    })
    m.top.signalBeacon(“AppDialogComplete”)
    return m.grid

end function

sub OnGridItemSelected(event as Object)
    print "Seleccion de show"
    grid = event.GetRoSGNode()
    selectedIndex = event.getdata()
    print selectedIndex
    if selectedIndex[0] = 0 and selectedIndex[1] = 0
        searchView = ShowSearchView()
        'detailsView.ObserveField("wasClosed", "OnSearchWasClosed")
    else
        rowContent = grid.content.getChild(selectedIndex[0])
        detailsView = ShowDetailsView(rowContent, selectedIndex[1])
        detailsView.ObserveField("wasClosed", "OnDetailsWasClosed")
    end if
end sub

sub OnDetailsWasClosed(event as Object)
    details = event.GetRoSGNode()
    m.grid.jumpToRowItem = [m.grid.rowItemFocused[0], details.itemFocused]
end sub

sub OnSearchWasClosed(event as Object)
    details = event.GetRoSGNode()
    m.grid.jumpToRowItem = [m.grid.rowItemFocused[0], details.itemFocused]
end sub
