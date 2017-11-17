$(document).ready(function () {
    /*Lo inicializo solo si tengo el selector presente */
    if (document.querySelector('.js-switch') != null) {
        var elem = document.querySelector('.js-switch');
        var init = new Switchery(elem);
    }


    if ($('body.ventas').length > 0){
        window.onbeforeunload = function(){
            return 'La venta no está cerrada, ¿seguro que quiere abandonar la página?';
        };
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
});