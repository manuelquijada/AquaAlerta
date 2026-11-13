from django import forms
from .models import ReporteAgua, ReporteCalidadAgua, ReporteServicioAgua

# ==========================================
# FORMULARIO: CALIDAD DEL AGUA
# ==========================================


class ReporteCalidadAguaForm(forms.ModelForm):

    fotografia = forms.FileField(
        required=False,
        label="Evidencia fotográfica",
        widget=forms.ClearableFileInput(
            attrs={
                "class": "form-control",
                "accept": "image/*",
            }
        ),
    )

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.fields["categoria"].required = True
        self.fields["ubicacion"].required = True

        self.fields["categoria"].empty_label = "Seleccione una categoría"
        self.fields["ubicacion"].empty_label = "Seleccione una ubicación"

    class Meta:
        model = ReporteCalidadAgua

        fields = [
            "titulo",
            "descripcion",
            "categoria",
            "ubicacion",
            "tipo_contaminacion",
            "apariencia_agua",
            "olor_agua",
        ]

        widgets = {
            "titulo": forms.TextInput(
                attrs={
                    "class": "form-control",
                    "placeholder": "Ejemplo: Presencia de sedimentos en el agua",
                }
            ),
            "descripcion": forms.Textarea(
                attrs={
                    "class": "form-control",
                    "rows": 4,
                    "placeholder": "Describa el problema encontrado",
                }
            ),
            "categoria": forms.Select(attrs={"class": "form-select"}),
            "ubicacion": forms.Select(attrs={"class": "form-select"}),
            "tipo_contaminacion": forms.TextInput(attrs={"class": "form-control"}),
            "apariencia_agua": forms.TextInput(attrs={"class": "form-control"}),
            "olor_agua": forms.TextInput(attrs={"class": "form-control"}),
        }


# ==========================================
# FORMULARIO: SERVICIO DE AGUA
# ==========================================


class ReporteServicioAguaForm(forms.ModelForm):

    fotografia = forms.FileField(
        required=False,
        label="Evidencia fotográfica",
        widget=forms.ClearableFileInput(
            attrs={
                "class": "form-control",
                "accept": "image/*",
            }
        ),
    )

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.fields["categoria"].required = True
        self.fields["ubicacion"].required = True

        self.fields["categoria"].empty_label = "Seleccione una categoría"
        self.fields["ubicacion"].empty_label = "Seleccione una ubicación"

    class Meta:
        model = ReporteServicioAgua

        fields = [
            "titulo",
            "descripcion",
            "categoria",
            "ubicacion",
            "tipo_problema",
            "estado_suministro",
            "detalle_afectacion",
        ]

        widgets = {
            "titulo": forms.TextInput(
                attrs={
                    "class": "form-control",
                    "placeholder": "Ejemplo: Interrupción del suministro",
                }
            ),
            "descripcion": forms.Textarea(
                attrs={
                    "class": "form-control",
                    "rows": 4,
                    "placeholder": "Describa el problema de suministro",
                }
            ),
            "categoria": forms.Select(attrs={"class": "form-select"}),
            "ubicacion": forms.Select(attrs={"class": "form-select"}),
            "tipo_problema": forms.TextInput(attrs={"class": "form-control"}),
            "estado_suministro": forms.TextInput(attrs={"class": "form-control"}),
            "detalle_afectacion": forms.Textarea(
                attrs={"class": "form-control", "rows": 4}
            ),
        }


# ==========================================
# FORMULARIO: EDITAR REPORTE (UPDATE)
# ==========================================


class ReporteAguaForm(forms.ModelForm):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.fields["categoria"].required = True
        self.fields["ubicacion"].required = True

        self.fields["categoria"].empty_label = "Seleccione una categoría"
        self.fields["ubicacion"].empty_label = "Seleccione una ubicación"

    class Meta:
        model = ReporteAgua

        fields = [
            "titulo",
            "descripcion",
            "categoria",
            "ubicacion",
            "prioridad",
            "estado",
        ]

        widgets = {
            "titulo": forms.TextInput(attrs={"class": "form-control"}),
            "descripcion": forms.Textarea(attrs={"class": "form-control", "rows": 4}),
            "categoria": forms.Select(attrs={"class": "form-select"}),
            "ubicacion": forms.Select(attrs={"class": "form-select"}),
            "prioridad": forms.Select(attrs={"class": "form-select"}),
            "estado": forms.TextInput(
                attrs={
                    "class": "form-control",
                    "placeholder": "Pendiente, En proceso o Resuelto",
                }
            ),
        }
