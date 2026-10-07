<main style="max-width:640px;margin:64px auto;padding:32px;font-family:system-ui,sans-serif;color:#17352b;">
  <p style="font-size:12px;letter-spacing:0.15em;">COCOCO / MODULE TEST</p>
  <h1>Hello from GitHub.</h1>
  <p>This counter is saved on the server. Reload the app to see it again.</p>
  <button type="button" @click="increment" :disabled="busy" style="padding:12px 20px;border:0;border-radius:8px;background:#17352b;color:white;cursor:pointer;">Say hello</button>
  <p aria-live="polite">{{ count === null ? 'Loading…' : 'Saved clicks: ' + count }}</p>
  <button type="button" @click="refresh" :disabled="busy">Refresh saved value</button>
  <p v-if="error" role="alert" style="color:#a32222;">{{ error }}</p>
</main>
