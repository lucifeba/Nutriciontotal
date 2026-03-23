"use client";

import { create } from 'zustand';

interface PlanState {
  selectedDayIndex: number;
  selectedMealType: string | null;
  isAddingFood: boolean;
  isAddingRecipe: boolean;
  searchQuery: string;
  selectedGrupo: string | null;
  setSelectedDay: (index: number) => void;
  setSelectedMealType: (type: string | null) => void;
  setIsAddingFood: (value: boolean) => void;
  setIsAddingRecipe: (value: boolean) => void;
  setSearchQuery: (query: string) => void;
  setSelectedGrupo: (grupo: string | null) => void;
  reset: () => void;
}

export const usePlanStore = create<PlanState>((set) => ({
  selectedDayIndex: 0,
  selectedMealType: null,
  isAddingFood: false,
  isAddingRecipe: false,
  searchQuery: '',
  selectedGrupo: null,
  setSelectedDay: (index) => set({ selectedDayIndex: index }),
  setSelectedMealType: (type) => set({ selectedMealType: type }),
  setIsAddingFood: (value) => set({ isAddingFood: value }),
  setIsAddingRecipe: (value) => set({ isAddingRecipe: value }),
  setSearchQuery: (query) => set({ searchQuery: query }),
  setSelectedGrupo: (grupo) => set({ selectedGrupo: grupo }),
  reset: () =>
    set({
      selectedDayIndex: 0,
      selectedMealType: null,
      isAddingFood: false,
      isAddingRecipe: false,
      searchQuery: '',
      selectedGrupo: null,
    }),
}));
