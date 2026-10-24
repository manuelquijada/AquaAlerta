
from django.db import models
from django.conf import settings


class PerfilUsuario(models.Model):
    ROLES = [
        ('Habitante', 'Habitante'),
        ('Representante', 'Representante comunitario'),
        ('Administrador', 'Administrador'),
    ]

    usuario = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='perfil'
    )

    rol = models.CharField(
        max_length=20,
        choices=ROLES,
        default='Habitante'
    )

    comunidad = models.CharField(max_length=100, default='El Cóbano')
    telefono = models.CharField(max_length=20, blank=True)

    def es_representante(self):
        return self.rol in ['Representante', 'Administrador']

    def __str__(self):
        return f"{self.usuario.username} - {self.rol}"
