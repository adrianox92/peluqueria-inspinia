$(document).ready(function () {
    /*Lo inicializo solo si tengo el selector presente */
    if (document.querySelector('.js-switch') != null) {
        var elem = document.querySelector('.js-switch');
        var init = new Switchery(elem);
    }

/*
    if ($('body.ventas').length > 0) {
        window.onbeforeunload = function () {
            return 'La venta no está cerrada, ¿seguro que quiere abandonar la página?';
        };
    }
*/
    if ($('body.new').length > 0) {
        $('.datepicker').datepicker({
            format: 'dd/mm/yyyy',
            startDate: '-3d'
        });
    }

    /* Ventas */
    $('.box').on('click', function () {
        var $box_id = $(this).attr('id'),
            venta_id = $('#venta_id').val();
        $.ajax({
            url: "/gestion/ventas/" + venta_id + "/aniade_venta/" + $box_id + "",
            type: 'post'
        }).done(function (data) {
            if (data.status == 'ok') {
                var ultimo_indice = $('.tabla-productos-venta tbody tr:last td:first').text(),
                    nuevo_indice = parseInt(ultimo_indice) + 1,
                    newRowContent = "<tr><td>" + nuevo_indice + "</td><td>" + data.servicio_nombre_dn + "</td><td>" + data.precio_item + "</td></tr>";
                $('.cuenta').text(data.precio_total);
                $('.tabla-productos-venta tbody').append(newRowContent);

            }
        });
    })
    $('.box-producto').on('click', function () {
        var $box_id = $(this).attr('id'),
            venta_id = $('#venta_id').val();
        $.ajax({
            url: "/gestion/ventas/" + venta_id + "/aniade_producto/" + $box_id + "",
            type: 'post'
        }).done(function (data) {
            if (data.status == 'ok') {
                if ($('.tabla-productos-venta tbody tr:last').length > 0) {
                    var ultimo_indice = 0;
                } else {
                    var ultimo_indice = $('.tabla-productos-venta tbody tr:last td:first').text();
                }
                var nuevo_indice = parseInt(ultimo_indice) + 1,
                    newRowContentProducto = "<tr><td>" + nuevo_indice + "</td><td>" + data.producto_nombre_dn + "</td><td>" + data.precio_item + "</td></tr>";
                $('.cuenta').text(data.precio_total);
                $('.tabla-productos-venta tbody').append(newRowContentProducto);

            }
        });
    })
});