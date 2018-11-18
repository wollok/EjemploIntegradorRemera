class RemeraLisa {
	var property talle
	var property color
	const coloresBasicos = ["blanco","negro","gris"]
	
	method costoTalle() {
		if (talle>=empresa.talleMinimo() and talle<=empresa.talleIntermedio())
			return empresa.precioChico()
		if (talle>empresa.talleIntermedio() and talle<=empresa.talleMaximo())
			return empresa.precioGrande()
		throw new Exception("Talle Invalido")
	}
	
	method recargoColor() = if (coloresBasicos.contains(color)) 0 else 0.1
	
	method costo() = self.costoTalle() * (1 + self.recargoColor())

//	method costo() = self.costoTalle() * (1 + self.recargoColor()) + self.adicional()
//	method adicional() = 0 
		
	method descuento() = 0.1
	
}

class RemeraBordada inherits RemeraLisa {
	var property colores
	
	method costoBordado() = 20.max(colores*10) 
//	override method adicional() = colores*10.max(20)
	
	override method costo() = super() + self.costoBordado() //
	
	override method descuento() = 0 
}

class RemeraSublimada inherits RemeraLisa {
	var alto
	var ancho
	var property marca
	const valorCm2 = 0.50
	
	method superficie() = alto * ancho
	
	method costoSublimado() = self.superficie() * valorCm2 + marca.derechos()
//	override method adicional() = self.superficie() * valorCm2 + autor.derechos()
	
	override method costo() = super() + self.costoSublimado() //
	
	override method descuento() = if (marca.convenio()) 0.2 else 0.1
	
}
class Marca {
	var property derechos
	var property convenio = false
}

class Pedido {
	var remera 
	var cantidad
	var property sucursal
	
	method descuento() =
		if (cantidad>=sucursal.cantidadMinima())
			remera.descuento()
		else
			0
	
	method precio() = remera.costo() * cantidad * (1- self.descuento())	
	
	method color() = remera.color()
	method talle() = remera.talle()
}

class Sucursal {
	const property cantidadMinima
}

object empresa {
	const pedidos = []
	const sucursales = []

	const property talleMinimo = 32
	const property talleIntermedio = 40
	const property talleMaximo = 48
	var property precioChico = 80
	var property precioGrande = 100
	
	method agregarPedido(pedido) {
		pedidos.add(pedido)
	}
	
	method facturacionTotal() =
		pedidos.sum{pedido=>pedido.precio()}
	
	method pedidosSucursal(sucursal) = 
		pedidos.filter{pedido=>pedido.sucursal() == sucursal}
	
	method facturacionSucursal(sucursal) =
		self.pedidosSucursal(sucursal).sum{pedido=>pedido.precio()}
	
	method sucursalMayorFacturacion() =
		sucursales.max{sucursal=>self.facturacionSucursal(sucursal)}
	
	method cantPedidosColor(color) =
		pedidos.count{pedido=>pedido.color()==color}
	
	method pedidoMasCaro() =
		pedidos.max{pedido=>pedido.precio()}
	
	method sucursalesTodosLosTalles() =
		sucursales.filter{sucursal=>self.vendioTodosLosTalles(sucursal)}
	
	method vendioTodosLosTalles(sucursal) =
		self.todosLosTalles().all{talle=> self.vendioTalle(sucursal,talle)}
	
	method todosLosTalles() = 
		(talleMinimo..talleMaximo)
	
	method vendioTalle(sucursal,talle) =
		self.pedidosSucursal(sucursal).any{pedido=>pedido.talle()==talle}
}
