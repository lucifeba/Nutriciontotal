"use client";

import { useRef, useState, useCallback } from "react";
import { type EncuestaData } from "@/types/encuesta.types";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { ScrollArea } from "@/components/ui/scroll-area";

interface StepProps {
  data: EncuestaData;
  onChange: (data: Partial<EncuestaData>) => void;
}

const PRIVACY_TEXT = `POLITICA DE PRIVACIDAD Y PROTECCION DE DATOS

En cumplimiento del Reglamento (UE) 2016/679 del Parlamento Europeo y del Consejo, de 27 de abril de 2016 (RGPD), y de la Ley Organica 3/2018, de 5 de diciembre, de Proteccion de Datos Personales y garantia de los derechos digitales (LOPDGDD), le informamos de lo siguiente:

1. RESPONSABLE DEL TRATAMIENTO
El responsable del tratamiento de sus datos personales es el/la nutricionista colegiado/a titular de NutriPlan Pro.

2. FINALIDAD DEL TRATAMIENTO
Sus datos personales seran tratados con la finalidad de:
- Prestar el servicio de asesoramiento nutricional contratado.
- Elaborar planes nutricionales personalizados.
- Realizar el seguimiento de su evolucion nutricional y de salud.
- Gestionar la relacion profesional-paciente.
- Comunicarnos con usted mediante los canales proporcionados.

3. CATEGORIAS ESPECIALES DE DATOS
Para la correcta prestacion del servicio de nutricion, es necesario tratar datos relativos a su salud (datos de categoria especial segun el art. 9 RGPD). Estos datos incluyen:
- Historial medico y patologias.
- Alergias e intolerancias alimentarias.
- Medicacion y suplementacion.
- Datos antropometricos.
- Habitos alimentarios y de actividad fisica.
- Aspectos psicologicos relacionados con la alimentacion.

4. BASE JURIDICA
El tratamiento de sus datos se basa en:
- Su consentimiento explicito (art. 6.1.a y 9.2.a RGPD).
- La ejecucion del contrato de servicios profesionales (art. 6.1.b RGPD).
- El cumplimiento de obligaciones legales (art. 6.1.c RGPD).

5. DESTINATARIOS
Sus datos no seran cedidos a terceros, salvo obligacion legal. No se realizaran transferencias internacionales de datos.

6. CONSERVACION
Sus datos seran conservados durante el tiempo necesario para la prestacion del servicio y, posteriormente, durante los plazos legales de conservacion aplicables.

7. DERECHOS
Usted tiene derecho a acceder, rectificar, suprimir, limitar, portar y oponerse al tratamiento de sus datos. Puede ejercer estos derechos dirigiendose al responsable del tratamiento. Asimismo, tiene derecho a presentar una reclamacion ante la Agencia Espanola de Proteccion de Datos (www.aepd.es).

8. MEDIDAS DE SEGURIDAD
Se han implementado las medidas tecnicas y organizativas necesarias para garantizar la seguridad de sus datos personales y evitar su alteracion, perdida, tratamiento o acceso no autorizado.`;

export function ConsentimientoFinal({ data, onChange }: StepProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [hasDrawn, setHasDrawn] = useState(false);
  const [useTextSignature, setUseTextSignature] = useState(true);

  const startDrawing = useCallback(
    (e: React.MouseEvent<HTMLCanvasElement>) => {
      const canvas = canvasRef.current;
      if (!canvas) return;
      const ctx = canvas.getContext("2d");
      if (!ctx) return;
      setIsDrawing(true);
      const rect = canvas.getBoundingClientRect();
      ctx.beginPath();
      ctx.moveTo(e.clientX - rect.left, e.clientY - rect.top);
    },
    []
  );

  const draw = useCallback(
    (e: React.MouseEvent<HTMLCanvasElement>) => {
      if (!isDrawing) return;
      const canvas = canvasRef.current;
      if (!canvas) return;
      const ctx = canvas.getContext("2d");
      if (!ctx) return;
      const rect = canvas.getBoundingClientRect();
      ctx.lineWidth = 2;
      ctx.lineCap = "round";
      ctx.strokeStyle = "#000";
      ctx.lineTo(e.clientX - rect.left, e.clientY - rect.top);
      ctx.stroke();
      setHasDrawn(true);
    },
    [isDrawing]
  );

  const stopDrawing = useCallback(() => {
    setIsDrawing(false);
    if (hasDrawn && canvasRef.current) {
      const dataUrl = canvasRef.current.toDataURL();
      onChange({ firmaDigital: dataUrl });
    }
  }, [hasDrawn, onChange]);

  const clearCanvas = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    setHasDrawn(false);
    onChange({ firmaDigital: undefined });
  };

  return (
    <div className="space-y-8">
      {/* Politica de privacidad */}
      <div className="space-y-3">
        <Label>Politica de Privacidad y Proteccion de Datos</Label>
        <ScrollArea className="h-64 w-full rounded-md border p-4">
          <div className="whitespace-pre-wrap text-sm text-muted-foreground leading-relaxed">
            {PRIVACY_TEXT}
          </div>
        </ScrollArea>
      </div>

      {/* Consentimientos */}
      <div className="space-y-4 p-4 bg-amber-50 rounded-lg border border-amber-200">
        <h4 className="font-medium text-amber-800">Consentimientos obligatorios</h4>

        <div className="flex items-start space-x-3">
          <Checkbox
            id="aceptaPrivacidad"
            checked={data.aceptaPoliticaPrivacidad || false}
            onCheckedChange={(checked) =>
              onChange({ aceptaPoliticaPrivacidad: !!checked })
            }
          />
          <Label htmlFor="aceptaPrivacidad" className="font-normal text-sm leading-relaxed">
            He leido y acepto la politica de privacidad. Entiendo que mis datos
            seran tratados conforme a lo indicado.
          </Label>
        </div>

        <div className="flex items-start space-x-3">
          <Checkbox
            id="aceptaDatos"
            checked={data.aceptaTratamientoDatos || false}
            onCheckedChange={(checked) =>
              onChange({ aceptaTratamientoDatos: !!checked })
            }
          />
          <Label htmlFor="aceptaDatos" className="font-normal text-sm leading-relaxed">
            Consiento expresamente el tratamiento de mis datos de salud
            (categoria especial de datos segun el RGPD) para la elaboracion de
            mi plan nutricional personalizado.
          </Label>
        </div>
      </div>

      {/* Firma */}
      <div className="space-y-3">
        <Label>Firma digital</Label>

        <div className="flex gap-2 mb-2">
          <Button
            type="button"
            variant={useTextSignature ? "default" : "outline"}
            size="sm"
            onClick={() => setUseTextSignature(true)}
          >
            Escribir nombre
          </Button>
          <Button
            type="button"
            variant={!useTextSignature ? "default" : "outline"}
            size="sm"
            onClick={() => setUseTextSignature(false)}
          >
            Dibujar firma
          </Button>
        </div>

        {useTextSignature ? (
          <div className="space-y-2">
            <Input
              placeholder="Escribe tu nombre completo como firma"
              value={data.firmaDigital || ""}
              onChange={(e) => onChange({ firmaDigital: e.target.value })}
            />
            <p className="text-xs text-muted-foreground">
              Tu nombre completo actuara como firma digital de este documento.
            </p>
          </div>
        ) : (
          <div className="space-y-2">
            <div className="border rounded-md bg-white relative">
              <canvas
                ref={canvasRef}
                width={500}
                height={150}
                className="w-full cursor-crosshair"
                onMouseDown={startDrawing}
                onMouseMove={draw}
                onMouseUp={stopDrawing}
                onMouseLeave={stopDrawing}
              />
              {!hasDrawn && (
                <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                  <p className="text-muted-foreground text-sm">
                    Dibuja tu firma aqui
                  </p>
                </div>
              )}
            </div>
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={clearCanvas}
            >
              Borrar firma
            </Button>
          </div>
        )}
      </div>

      {/* Resumen de validacion */}
      {(!data.aceptaPoliticaPrivacidad || !data.aceptaTratamientoDatos) && (
        <div className="p-3 bg-red-50 rounded-md border border-red-200">
          <p className="text-sm text-red-600">
            Debes aceptar ambos consentimientos para poder enviar la encuesta.
          </p>
        </div>
      )}
    </div>
  );
}
