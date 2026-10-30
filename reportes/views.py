from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.admin.views.decorators import staff_member_required

from .models import ReporteAgua, ReporteCalidadAgua, ReporteServicioAgua

from .forms import (
    ReporteAguaForm,
    ReporteCalidadAguaForm,
    ReporteServicioAguaForm,
)
def inicio(request):
    total_calidad = ReporteCalidadAgua.objects.count()
    total_servicio = ReporteServicioAgua.objects.count()

    contexto = {
        'total_calidad': total_calidad,
        'total_servicio': total_servicio,
        'total_reportes': total_calidad + total_servicio,
    }

    return render(request, 'reportes/inicio.html', contexto)


def lista_reportes(request):
    reportes = ReporteAgua.objects.select_related(
        'categoria',
        'ubicacion',
        'usuario'
    ).order_by('-fecha_reporte')

    contexto = {
        'reportes': reportes
    }

    return render(request, 'reportes/lista_reportes.html', contexto)

def crear_reporte_calidad(request):
    if request.method == 'POST':
        formulario = ReporteCalidadAguaForm(request.POST)

        if formulario.is_valid():
            reporte = formulario.save(commit=False)

            if request.user.is_authenticated:
                reporte.usuario = request.user

            reporte.save()
            return redirect('lista_reportes')

    else:
        formulario = ReporteCalidadAguaForm()

    contexto = {
        'formulario': formulario,
        'tipo_reporte': 'Calidad del agua',
    }

    return render(
        request,
        'reportes/formulario_reporte.html',
        contexto
    )


def crear_reporte_servicio(request):
    if request.method == 'POST':
        formulario = ReporteServicioAguaForm(request.POST)

        if formulario.is_valid():
            reporte = formulario.save(commit=False)

            if request.user.is_authenticated:
                reporte.usuario = request.user

            reporte.save()
            return redirect('lista_reportes')

    else:
        formulario = ReporteServicioAguaForm()

    contexto = {
        'formulario': formulario,
        'tipo_reporte': 'Servicio de agua',
    }

    return render(
        request,
        'reportes/formulario_reporte.html',
        contexto
    )

@staff_member_required
def editar_reporte(request, reporte_id):
    reporte = get_object_or_404(ReporteAgua, id=reporte_id)

    if request.method == 'POST':
        formulario = ReporteAguaForm(request.POST, instance=reporte)

        if formulario.is_valid():
            formulario.save()
            return redirect('lista_reportes')
    else:
        formulario = ReporteAguaForm(instance=reporte)

    contexto = {
        'formulario': formulario,
        'tipo_reporte': 'Editar reporte',
    }

    return render(request, 'reportes/formulario_reporte.html', contexto)

@staff_member_required
def eliminar_reporte(request, reporte_id):
    reporte = get_object_or_404(ReporteAgua, id=reporte_id)

    if request.method == 'POST':
        reporte.delete()
        return redirect('lista_reportes')

    return render(
        request,
        'reportes/confirmar_eliminacion.html',
        {'reporte': reporte}
    )