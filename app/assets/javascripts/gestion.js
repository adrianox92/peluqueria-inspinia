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
            startDate: '-3d',
            language: 'es',
            regional: 'es',
            weekStart: 1,
            todayHighlight: true
        });
    }
    if ($('.datepicker2').length > 0) {
        $('.datepicker2').datepicker({
            format: 'dd/mm/yyyy',
            language: 'es',
            weekStart: 1,
            regional: 'es',
            todayHighlight: true,
            startDate: '01/01/2017'
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

                var id_producto = '#' + data.producto_id;
                if (data.stock == 0) {
                    $('#productos ' + id_producto).addClass('sin-stock');
                }

                $('#productos ' + id_producto + ' .stock-bajo').data('original-title', "Unidades disponibles: " + data.stock)
                $('#productos ' + id_producto + ' .stock-bajo').attr('data-original-title', "Unidades disponibles: " + data.stock)
            }
            else{
                swal ( "Error" ,  "Stock disponible 0" ,  "error" )
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
                    $('.cuenta').text((data.precio_total).toFixed(2));
                    $('.tabla-productos-venta tbody tr#' + data.id).remove();
                    var id_producto = '#' + data.producto_id;

                    $('#productos ' + id_producto + ' .stock-bajo').data('original-title', "Unidades disponibles: " + data.stock_nuevo);
                    $('#productos ' + id_producto + ' .stock-bajo').attr('data-original-title', "Unidades disponibles: " + data.stock_nuevo);

                    $('#productos ' + id_producto).removeClass('sin-stock');
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
            array_colores = [
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
            array_precios_mes.push(valor.total_servicio);
            array_usados_mes.push(valor.usado);
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

    if ($('body.citas').length > 0) {
        $('#calendar').fullCalendar({
            locale: 'es',
            lang: 'es', //lang is Spanish
            header: {
                left: 'today',
                right: 'prev,next'
            },
            buttonText: {
                prev: '<',
                next: '>',
                today: 'Hoy'
            },
            validRange: {
                start: moment(new Date()).add(-1, 'days')
            },
            timezone: 'local',
            editable: false, //enable event edit
            axisFormat: 'HH:mm', //format for hours
            axisFormatMinutes: "mm", //format for minutes
            allDaySlot: false, // all day row
            allDayText: '', //text for all day row
            eventLimit: 20, //limits the number of events displayed on a day
            eventLimitText: 'más', //determines the text of the link created by eventLimit setting.
            lazyFetching: false,
            height: "auto",
            slotEventOverlap: false,
            firstHour: 8,
            minTime: "07:00:00",
            maxTime: "23:00:00",
            slotDuration: '00:30:00',
            slotLabelInterval: '00:30:00',
            eventOverlap: false,
            droppable: false, // this allows things to be dropped onto the calendar !!!
            hiddenDays: [0],
            firstDay: 1,
            nowIndicator: true,
            scrollTime: '08:00:00',
            monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
            monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
            dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
            dayNamesShort: ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab'],
            defaultView: 'agendaWeek',
            events: $('#calendar').data('citas'),
            businessHours: $('#calendar').data('horario-apertura'),
            dayRender: function (date, cell) {
                if (moment(date).format('x') < moment().subtract(1, 'days').format('x')) {
                    $(cell).addClass('disabled');
                }
            },
            dayClick: function (startDate, jsEvent, view) { //empty day click callback
                d = startDate.toDate();
                date = new Date(d);
                date_options = moment(date).format('YYYY-MM-DD$HH:mm:ss');
                if (!date < moment(new Date()).add(-1, 'days')) {
                    $('#myModal').modal('show');
                } else {
                    alert("Cita fuera de horario comercial")
                }
            }

        });
    }
});