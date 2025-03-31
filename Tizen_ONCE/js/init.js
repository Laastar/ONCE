
App.Navigation.registerMenu({
    domEl: document.querySelector('#mensajeSalida'),
    name: 'mensajeSalida',
    alignment: 'line'
});

const searchBox = document.getElementById("search-box");
const canalesBox = document.getElementById("menus");
const resutlsBox = document.getElementById("busquedaDin");
searchBox.addEventListener("keyup", buscarCanal);

function buscarCanal() {
	var matcher = searchBox.value;
	if(matcher === "") {
		resutlsBox.innerHTML = "";
	}
	else {
		var elements = canalesBox.querySelectorAll("[id*="+matcher);

		var busquedaHTML = "";
		if(elements.length > 0) {
			for (var i = 0; i < 10; i++) {
				busquedaHTML += "<a data-list-item id='' type='button' class='btn button' role='button' style='color: #FFFFFF'>" + elements[i].id + "</a>";			
			}
		}
		resutlsBox.innerHTML = busquedaHTML;
	}
}

var nombreCategorias = [];

async function traerCanales() {
	const response = await fetch('https://canaloncetv.s3.amazonaws.com/REST/data/mdb/channels.json');
	const shows = await response.json();

	var categorias = [];
	var elementoCategorias = [];
	
	for (var i = 0; i < shows.length; i++) {
			if (shows[i].n_categoria &&  !nombreCategorias.includes(shows[i].n_categoria)) {
				categorias.push(shows[i].category);
				nombreCategorias.push(shows[i].n_categoria);
				elementoCategorias.push(i);
			}
	}
	
	for (i = 0; i < categorias.length; i++) {
		if(i === 0) {
			generadorHTML(categorias[i], nombreCategorias[i], i);
		}
		else {
			generadorHTML(categorias[i], nombreCategorias[i], i, categorias[i-1], nombreCategorias[i-1]);
		}
	}
	
	for (i = 0; i < shows.length; i++) {
		var html = "<div class='item'> <a data-list-item id='" + shows[i].slugc + "' type='button' class='btn button' role='button'> <div>"
			+ "<img src='https://canalonce.mx/REST/data/normal/"+ shows[i].imageWN +"' class='imagen-card'></div></a></div>";
		console.log(html);
		console.log(shows[i].category);
		console.log(document.getElementById(shows[i].category));
		document.getElementById(shows[i].category).insertAdjacentHTML("beforeend", html);
	}
	
	
	for (i = 0; i < categorias.length; i++) {
		if(i === 0) {
			generadorMenus(null, nombreCategorias[i], nombreCategorias[i+1], i);
		}
		else if (i === categorias.length-1){
			var j = 'max';
			generadorMenus(nombreCategorias[i-1], nombreCategorias[i], null, j);
		}
		else {
			generadorMenus(nombreCategorias[i-1], nombreCategorias[i], nombreCategorias[i+1], i);
		}
	}
	
	App.Navigation.changeActiveMenu(nombreCategorias[0], 0);
}

async function traerImagenHorizontal(imagen) {
	const response = await fetch('https://canalonce.mx/REST/data/normal/' + imagen);
	return response.blob();
}

function generadorHTML(cat, n_cat, i, ant_cat, act_n_cat) {
	n_cat = n_cat.replace(/\s/g, '');
	var html = "<h1 style='color: #FFFFFF'>" + n_cat + "<br /></h1><section id='" + n_cat + "'> <div class='wrapper'> <section id='" + cat + "' class='seccion'> </section></div></section>";
	document.getElementById('menus').innerHTML += html;
}

function generadorMenus(catAnterior, catNombre, catSiguiente, i) {
	if(i === 'max') {
		catAnterior = catAnterior.replace(/\s/g, '');
		catNombre = catNombre.replace(/\s/g, '');
		App.Navigation.registerMenu({
	        domEl: document.querySelector('#' + catNombre),
	        name: catNombre,
	        alignment: 'line',
	        previousMenu: catAnterior,
	        initial: "yes"
	    });
	}
	else if(i === 0) {
		catNombre = catNombre.replace(/\s/g, '');
		catSiguiente = catSiguiente.replace(/\s/g, '');
		App.Navigation.registerMenu({
	        domEl: document.querySelector('#' + catNombre),
	        name: catNombre,
	        alignment: 'line',
	        nextMenu: catSiguiente,
	        initial: "yes"
	    });
	} else {
		catAnterior = catAnterior.replace(/\s/g, '');
		catNombre = catNombre.replace(/\s/g, '');
		catSiguiente = catSiguiente.replace(/\s/g, '');
		App.Navigation.registerMenu({
	        domEl: document.querySelector('#' + catNombre),
	        name: catNombre,
	        alignment: 'line',
	        previousMenu: catAnterior,
	        nextMenu: catSiguiente,
	        initial: "yes"
	    });
	}
}

document.getElementById('salirApp').onclick = function() { tizen.application.getCurrentApplication().exit(); };

document.getElementById('seguirApp').onclick = function() { 
	var element = document.getElementById('mensajeSalida');
	element.setAttribute("style", "display:none");
	App.Navigation.changeActiveMenu(nombreCategorias[0], 0); 
};

/*webapis.network.addNetworkStateChangeListener(function(value) {
	console.log(value)
	if (value == webapis.network.NetworkState.GATEWAY_DISCONNECTED || value == 0) {
		console.log("Sin red");
	} else {
		console.log("Con red");
	}
});*/

/*var player = videojs('my-player');
var pivote = player.controlBar.getChild("ProgressControl");


var indexS = player.controlBar.children().indexOf(pivote);

var botonS = player.controlBar.addChild("button", {}, indexS);
var botonSDom = botonS.el();
botonSDom.innerHTML = "<span><i class='fa-solid fa-forward-step'></i></span>";
botonSDom.onclick = function() {
	alert("Siguiente episodio");
}

var botonA = player.controlBar.addChild("button", {}, 0);
var botonADom = botonA.el();
botonADom.innerHTML = "<span><i class='fa-solid fa-backward-step'></i></span>";
botonADom.onclick = function() {
	alert("Episodio anterior");
}

App.Navigation.registerMenu({
    domEl: document.querySelector('#my-player'),
    name: 'reproductor'
});*/

traerCanales();
