$(document).ready(function () {
    /*Lo inicializo solo si tengo el selector presente */
    if (document.querySelector('.js-switch') != null) {
        var elem = document.querySelector('.js-switch');
        var init = new Switchery(elem);
    }


     if ($('body.ventas').length > 0) {
         $(".chosen-select").chosen({
             no_results_text: "Cliente no encontrado",
             allow_single_deselect: true,
             placeholder_text_single: 'Seleccione cliente'
         });
         /*
      window.onbeforeunload = function () {
      return 'La venta no está cerrada, ¿seguro que quiere abandonar la página?';
      };*/
     }

    if ($('.datepicker').length > 0) {
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
                    newRowContent = "<tr id='" + data.id_item + "'>" +
                        "<td>" + nuevo_indice + "</td>" +
                        "<td>" + data.servicio_nombre_dn + "</td>" +
                        "<td>" + data.precio_item + "</td>" +
                        "<td><span id='" + data.id_item + "' data-tipo='" + data.tipo + "' class='eliminar glyphicon glyphicon-remove'></span></td>" +
                        "</tr>";
                $('.cuenta').text((data.precio_total).toFixed(2));
                $('.tabla-productos-venta tbody').append(newRowContent);

            }
        });
    });

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
                    newRowContentProducto = "<tr id='" + data.id_item + "'>" +
                        "<td>" + nuevo_indice + "</td>" +
                        "<td>" + data.producto_nombre_dn + "</td>" +
                        "<td>" + data.precio_item + "</td>" +
                        "<td><span id='" + data.id_item + "' data-tipo='" + data.tipo + "' class='eliminar glyphicon glyphicon-remove'></span></td>" +
                        "</tr>";
                $('.cuenta').text((data.precio_total).toFixed(2));
                $('.tabla-productos-venta tbody').append(newRowContentProducto);

                if (data.stock == 0) {
                    console.log(data.id_item);
                    var id_producto = '#' + data.producto_id
                    $('#productos ' + id_producto).remove();
                }
            }
        });
    });
    if ($('body.ventas').length > 0) {
        $(document).on('click', '.eliminar', function () {
            var servicio_id = $(this).attr('id'),
                venta_id = $('#venta_id').val(),
                tipo = $(this).data('tipo');
            $.ajax({
                url: "/gestion/ventas/" + venta_id + "/elimina_linea_venta/" + servicio_id + "/" + tipo + '',
                type: 'post'
            }).done(function (data) {
                if (data.status == 'ok') {
                    //TODO: Si el producto tenía 0 como lo hemos eliminado tenemos que volverlo a crear
                    $('.cuenta').text((data.precio_total).toFixed(2));
                    $('.tabla-productos-venta tbody tr#' + data.id).remove();
                }
                if (data.status == 'ko') {
                    alert('error');
                }

            });
        });
    }

    /* Estadísticas */
    if ($('body.estadisticas').length > 0) {
        var data = JSON.parse($('#productos_semana').val()),
            data_mensual = JSON.parse($('#productos_mes').val()),
            array_servicios = [],
            array_precios = [],
            array_usados = [],
            array_servicios_mes = [],
            array_precios_mes = [],
            array_usados_mes = [],
            ctx = document.getElementById("chart_semanal").getContext('2d'),
            ctx3 = document.getElementById("chart_mensual").getContext('2d'),
            ctx2 = document.getElementById("line_semanal").getContext('2d'),
            array_background = [
                'rgba(255, 99, 132, 0.2)',
                'rgba(54, 162, 235, 0.2)',
                'rgba(255, 206, 86, 0.2)',
                'rgba(75, 192, 192, 0.2)',
                'rgba(153, 102, 255, 0.2)',
                'rgba(12, 119, 15, 0.2)',
                'rgba(211, 22, 249, 0.2)',
                'rgba((200, 21, 82, 0.2)',
                'rgba(20, 249, 207, 0.2)',
                'rgba(249, 172, 20, 0.2)',
                'rgba(255, 159, 64, 0.2)',
                'rgba(15, 246, 33, 0.2)',
                'rgba(246, 55, 33, 0.2)'
            ],
            array_colores =[
                'rgba(255,99,132,1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(12, 119, 15, 1)',
                'rgba(211, 22, 249, 1)',
                'rgba((200, 21, 82, 1)',
                'rgba(20, 249, 207, 1)',
                'rgba(249, 172, 20, 1)',
                'rgba(255, 159, 64, 1)',
                'rgba(15, 246, 33, 1)',
                'rgba(246, 55, 33, 1)'
            ];

        $.each(data, function (servicio, valor) {
            array_servicios.push(servicio);
            array_precios.push(data[servicio].total_servicio);
            array_usados.push(data[servicio].usado);

        });

        var myChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: array_servicios,
                datasets: [{
                    label: '# de servicios usados',
                    data: array_usados,
                    backgroundColor: array_background,
                    borderColor: array_colores,
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
            }
        });
        var data_semana_curso = JSON.parse($('#ventas_semana_total_grafica').val()),
            data_semana_anterior = JSON.parse($('#ventas_semana_anterior_total_grafica').val()),
            array_ventas_semana_anterior = [],
            array_ventas_semana_curso = [];
        $.each(data_semana_curso, function (total, valor) {
            array_ventas_semana_curso.push(valor.total_ventas)
        });

        $.each(data_semana_anterior, function (total, valor) {
            array_ventas_semana_anterior.push(valor.total_ventas)
        });

        var Chart_semanal = new Chart(ctx2, {
            type: 'line',
            data: {
                labels: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
                datasets: [

                    {
                        label: "Semana actual",
                        backgroundColor: 'rgba(26,179,148,0.5)',
                        borderColor: "rgba(26,179,148,0.7)",
                        pointBackgroundColor: "rgba(26,179,148,1)",
                        pointBorderColor: "#fff",
                        data: array_ventas_semana_curso
                    },
                    {
                        label: "Semana anterior",
                        backgroundColor: 'rgba(220, 220, 220, 0.5)',
                        pointBorderColor: "#fff",
                        data: array_ventas_semana_anterior
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                title: {
                    display: true,
                    text: 'Ingresos durante la semana comparada con la anterior'
                }
            }
        });
        $.each(data_mensual, function (servicio, valor) {
            array_servicios_mes.push(servicio);
            array_precios_mes.push(data[servicio].total_servicio);
            array_usados_mes.push(data[servicio].usado);

        });
        var myChartMensual = new Chart(ctx3, {
            type: 'doughnut',
            data: {
                labels: array_servicios_mes,
                datasets: [{
                    label: '# de servicios usados',
                    data: array_usados_mes,
                    backgroundColor: array_background,
                    borderColor: array_colores,
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
            }
        });
    }


    $('[data-toggle="tooltip"]').tooltip();
});