# Remediation Patches

## Patch 1: Mask Secrets in Logs

**Issue:** `LinkedInConfig` dataclass leaks sensitive information (password, cookie) in its default `__repr__` method, which is logged during debug mode.

**Fix:** Implement a custom `__repr__` method to mask these fields.

**File:** `linkedin_mcp_server/config/schema.py`

```python
@dataclass
class LinkedInConfig:
    """LinkedIn connection configuration."""

    email: Optional[str] = None
    password: Optional[str] = None
    cookie: Optional[str] = None

    def __repr__(self) -> str:
        """Mask sensitive data in logs."""
        return (
            f"LinkedInConfig(email={self.email!r}, "
            "password='***', "
            f"cookie={'***' if self.cookie else None})"
        )
```

## Patch 2: Dependency Pinning (Recommendation)

**Issue:** `pyproject.toml` uses a git dependency for `linkedin-scraper`.

**Fix:** Replace with a pinned version from a trusted source or a local audited vendor copy.

**File:** `pyproject.toml`

```toml
# CHANGE THIS:
# linkedin-scraper = { git = "https://github.com/stickerdaniel/linkedin_scraper.git" }

# TO THIS (Example, assuming a valid PyPI package exists or you host your own):
# linkedin-scraper = "2.11.1"
```
