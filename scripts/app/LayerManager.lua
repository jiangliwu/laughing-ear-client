LayerManager = {
	root=nil,
	layers = {}
}



function LayerManager.init( root ) 
	LayerManager.root = root
	LayerManager.layers['map'] = display.newLayer():addTo(root)
	LayerManager.layers['ui']  = display.newLayer():addTo(root)
	LayerManager.layers['window'] = display.newLayer():addTo(root)
end


