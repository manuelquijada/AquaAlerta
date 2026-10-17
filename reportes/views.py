
from django.shortcuts import render
from .models import ReporteCalidadAgua, ReporteServicioAgua


def inicio(request):
    total_calidad = ReporteCalidadAgua.objects.count()
    total_servicio = ReporteServicioAgua.objects.count()

    contexto = {
        'total_calidad': total_calidad,
        'total_servicio': total_servicio,
        'total_reportes': total_calidad + total_servicio,
    }

    return render(request, 'reportes/inicio.html', contexto)
