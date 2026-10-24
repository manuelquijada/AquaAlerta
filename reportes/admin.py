
from django.contrib import admin
from .models import (
    ReporteAgua,
    ReporteCalidadAgua,
    ReporteServicioAgua,
    Categoria,
    Ubicacion,
    Evidencia,
    Seguimiento,
)

admin.site.register(ReporteAgua)
admin.site.register(ReporteCalidadAgua)
admin.site.register(ReporteServicioAgua)
admin.site.register(Categoria)
admin.site.register(Ubicacion)
admin.site.register(Evidencia)
admin.site.register(Seguimiento)
