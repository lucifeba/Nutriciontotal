"use client";

import { useState } from "react";
import { trpc } from "@/lib/trpc";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { type EncuestaData } from "@/types/encuesta.types";
import { DatosPersonales } from "./steps/DatosPersonales";
import { HistorialMedico } from "./steps/HistorialMedico";
import { HabitosAlimentarios } from "./steps/HabitosAlimentarios";
import { ActividadFisica } from "./steps/ActividadFisica";
import { ObjetivosExpectativas } from "./steps/ObjetivosExpectativas";
import { RegistroDietetico } from "./steps/RegistroDietetico";
import { AspectoPsicologico } from "./steps/AspectoPsicologico";
import { ConsentimientoFinal } from "./steps/ConsentimientoFinal";

interface EncuestaWizardProps {
  token: string;
  pacienteNombre: string;
}

const STEPS = [
  { number: 1, title: "Datos Personales", component: DatosPersonales },
  { number: 2, title: "Historial Medico", component: HistorialMedico },
  { number: 3, title: "Habitos Alimentarios", component: HabitosAlimentarios },
  { number: 4, title: "Registro Dietetico 24h", component: RegistroDietetico },
  { number: 5, title: "Actividad Fisica", component: ActividadFisica },
  { number: 6, title: "Objetivos y Expectativas", component: ObjetivosExpectativas },
  { number: 7, title: "Aspecto Psicologico", component: AspectoPsicologico },
  { number: 8, title: "Consentimiento Final", component: ConsentimientoFinal },
];

export function EncuestaWizard({ token, pacienteNombre }: EncuestaWizardProps) {
  const [currentStep, setCurrentStep] = useState(0);
  const [formData, setFormData] = useState<EncuestaData>({});
  const [submitted, setSubmitted] = useState(false);

  const submitMutation = trpc.encuestas.submit.useMutation({
    onSuccess: () => {
      setSubmitted(true);
    },
  });

  const updateFormData = (stepData: Partial<EncuestaData>) => {
    setFormData((prev) => ({ ...prev, ...stepData }));
  };

  const handleNext = () => {
    if (currentStep < STEPS.length - 1) {
      setCurrentStep((prev) => prev + 1);
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  };

  const handlePrevious = () => {
    if (currentStep > 0) {
      setCurrentStep((prev) => prev - 1);
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  };

  const handleSubmit = () => {
    submitMutation.mutate({ token, data: formData });
  };

  if (submitted) {
    return (
      <Card className="max-w-2xl mx-auto">
        <CardContent className="pt-8 pb-8 text-center">
          <div className="text-6xl mb-6">&#127881;</div>
          <h2 className="text-2xl font-bold text-green-700 mb-3">
            Encuesta enviada correctamente
          </h2>
          <p className="text-muted-foreground mb-2">
            Gracias, {pacienteNombre}. Tu nutricionista revisara tus respuestas
            y se pondra en contacto contigo pronto.
          </p>
          <p className="text-sm text-muted-foreground">
            Ya puedes cerrar esta pagina.
          </p>
        </CardContent>
      </Card>
    );
  }

  const progress = ((currentStep + 1) / STEPS.length) * 100;
  const step = STEPS[currentStep];
  const StepComponent = step.component;

  return (
    <div className="space-y-6">
      {/* Progress Section */}
      <div className="space-y-3">
        <div className="flex items-center justify-between text-sm">
          <span className="font-medium text-green-700">
            Paso {step.number} de {STEPS.length}
          </span>
          <span className="text-muted-foreground">
            {Math.round(progress)}% completado
          </span>
        </div>
        <Progress value={progress} className="h-2" />
        <div className="flex gap-1">
          {STEPS.map((s, i) => (
            <div
              key={s.number}
              className={`h-1 flex-1 rounded-full transition-colors ${
                i <= currentStep ? "bg-green-500" : "bg-gray-200"
              }`}
            />
          ))}
        </div>
      </div>

      {/* Step Content */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-3">
            <span className="flex items-center justify-center h-8 w-8 rounded-full bg-green-100 text-green-700 text-sm font-bold">
              {step.number}
            </span>
            {step.title}
          </CardTitle>
        </CardHeader>
        <CardContent>
          <StepComponent data={formData} onChange={updateFormData} />
        </CardContent>
      </Card>

      {/* Navigation */}
      <div className="flex justify-between">
        <Button
          variant="outline"
          onClick={handlePrevious}
          disabled={currentStep === 0}
        >
          Anterior
        </Button>

        {currentStep < STEPS.length - 1 ? (
          <Button onClick={handleNext}>Siguiente</Button>
        ) : (
          <Button
            onClick={handleSubmit}
            disabled={
              submitMutation.isPending ||
              !formData.aceptaPoliticaPrivacidad ||
              !formData.aceptaTratamientoDatos
            }
            className="bg-green-600 hover:bg-green-700"
          >
            {submitMutation.isPending ? "Enviando..." : "Enviar Encuesta"}
          </Button>
        )}
      </div>

      {submitMutation.error && (
        <p className="text-red-500 text-sm text-center">
          Error al enviar la encuesta. Por favor, intentalo de nuevo.
        </p>
      )}
    </div>
  );
}
