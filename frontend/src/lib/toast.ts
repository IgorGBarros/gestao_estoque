// src/lib/toast.ts
import { useToast as useOriginalToast } from "@/hooks/use-toast";

/**
 * ✅ Wrapper 100% seguro para toast - nunca lança erro
 */
export function useToast() {
  // cast to any to avoid incorrect inferred "never" call signature
  const original: any = useOriginalToast();

  return (props: any) => {
    try {
      if (typeof original === "function") return original(props);
      if (original?.toast && typeof original.toast === "function") return original.toast(props);
    } catch (e) {
      console.warn("⚠️ Toast fallback:", props?.title);
    }
  };
}