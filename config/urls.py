from django.contrib import admin
from django.urls import path
from reportes.views import (
    inicio,
    lista_reportes,
    crear_reporte_calidad,
    crear_reporte_servicio,
    editar_reporte,
    eliminar_reporte,

)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', inicio, name='inicio'),
    path('reportes/', lista_reportes, name='lista_reportes'),

    path(
        'reportes/nuevo/calidad/',
        crear_reporte_calidad,
        name='crear_reporte_calidad'
    ),

    path(
        'reportes/nuevo/servicio/',
        crear_reporte_servicio,
        name='crear_reporte_servicio'
    ),

        path(
        'reportes/editar/<int:reporte_id>/',
        editar_reporte,
        name='editar_reporte'
    ),

    path(
    'reportes/eliminar/<int:reporte_id>/',
    eliminar_reporte,
    name='eliminar_reporte'
),
]