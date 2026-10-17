from django.db import models


class ReporteAgua(models.Model):
    PRIORIDADES = [
        ('Alta', 'Alta'),
        ('Media', 'Media'),
        ('Baja', 'Baja'),
    ]

    titulo = models.CharField(max_length=150)
    descripcion = models.TextField()
    fecha_reporte = models.DateTimeField(auto_now_add=True)
    estado = models.CharField(max_length=30, default='Pendiente')
    prioridad = models.CharField(
        max_length=10,
        choices=PRIORIDADES,
        default='Media'
    )

    def obtener_tipo_reporte(self):
        return "Reporte general de agua"

    def __str__(self):
       return self.titulo

    
class ReporteCalidadAgua(ReporteAgua):
    tipo_contaminacion = models.CharField(max_length=100)
    apariencia_agua = models.CharField(max_length=100)
    olor_agua = models.CharField(max_length=100)

    def obtener_tipo_reporte(self):
        return "Reporte de calidad del agua"


class ReporteServicioAgua(ReporteAgua):
    tipo_problema = models.CharField(max_length=100)
    estado_suministro = models.CharField(max_length=100)
    detalle_afectacion = models.TextField()

    def obtener_tipo_reporte(self):
        return "Reporte de servicio de agua"


