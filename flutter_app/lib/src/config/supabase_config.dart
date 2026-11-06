abstract final class SupabaseConfig {
  static const url = String.fromEnvironment(
    "SUPABASE_URL",
    defaultValue: "https://rchsglmfecttutixzxht.supabase.co",
  );

  // Supabase anon keys are public client configuration. Authorization is still
  // enforced by the guest JWT and the Edge Function on every request.
  static const anonKey = String.fromEnvironment(
    "SUPABASE_ANON_KEY",
    defaultValue:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJjaHNnbG1mZWN0dHV0aXh6eGh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTM3Mjc5MDgsImV4cCI6MjEwOTMwMzkwOH0.jn20kOuJD_qp-mdFRqMijQerdsp4tNgh8RfSYBo-z4Q",
  );

  static const functionBaseUrl = "$url/functions/v1/server";
}
