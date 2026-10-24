from django.db import models



class ReporteAgua(models.Model):
    PRIORIDADES = [
        ('Alta', 'Alta'),
        ('Media', 'Media'),
        ('Baja', 'Baja'),
    ]

    usuario = models.ForeignKey(
        'auth.User',
        on_delete=models.PROTECT,
        related_name='reportes_agua',
        null=True,
        blank=True
    )
 
    categoria = models.ForeignKey(
        'reportes.Categoria',
        on_delete=models.PROTECT,
        related_name='reportes',
        null=True,
        blank=True
    )  
    ubicacion = models.ForeignKey(
        'reportes.Ubicacion',
        on_delete=models.PROTECT,
        related_name='reportes',
        null=True,
        blank=True
    )
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


class Categoria(models.Model):
    nombre = models.CharField(max_length=100, unique=True)
    descripcion = models.TextField(blank=True)

    def es_calidad_agua(self):
        return 'calidad' in self.nombre.lower()

    def __str__(self):
        return self.nombre


class Ubicacion(models.Model):
    comunidad = models.CharField(max_length=100, default='El Cóbano')
    sector = models.CharField(max_length=100)
    referencia = models.TextField(blank=True)

    def obtener_direccion(self):
        return f"{self.sector}, {self.comunidad}"

    def __str__(self):
        return self.obtener_direccion()

    class Meta:
        verbose_name = 'Ubicación'
        verbose_name_plural = 'Ubicaciones'



class Evidencia(models.Model):
    reporte = models.ForeignKey(
        'reportes.ReporteAgua',
        on_delete=models.CASCADE,
        related_name='evidencias'
    )
    archivo = models.FileField(upload_to='evidencias/', blank=True, default='')
    descripcion = models.TextField(blank=True)
    fecha_registro = models.DateTimeField(auto_now_add=True, null=True)

    def obtener_nombre_archivo(self):
        return self.archivo.name.split('/')[-1]

    def __str__(self):
        return f"Evidencia del reporte {self.reporte_id}"


class Seguimiento(models.Model):
    reporte = models.ForeignKey(
        'reportes.ReporteAgua',
        on_delete=models.CASCADE,
        related_name='seguimientos'
    )
    usuario = models.ForeignKey(
    'auth.User',
    on_delete=models.PROTECT,
    related_name='seguimientos_realizados',
    null=True,
    blank=True
)
    observacion = models.TextField(blank=True, default='')
    fecha_seguimiento = models.DateTimeField(null=True, blank=True)

    def obtener_resumen(self):
        return self.observacion[:100]

    def __str__(self):
        return f"Seguimiento del reporte {self.reporte_id}"

   