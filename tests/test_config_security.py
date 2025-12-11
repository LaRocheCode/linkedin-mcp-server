import pytest
import logging
from linkedin_mcp_server.config.schema import LinkedInConfig

def test_linkedin_config_repr_masks_secrets():
    """Test that LinkedInConfig.__repr__ masks sensitive data."""
    config = LinkedInConfig(
        email="test@example.com",
        password="supersecretpassword",
        cookie="li_at=verysecretcookievalue"
    )

    repr_str = repr(config)

    # Check that email is visible
    assert "test@example.com" in repr_str

    # Check that secrets are NOT visible
    assert "supersecretpassword" not in repr_str
    assert "verysecretcookievalue" not in repr_str

    # Check that masks are present
    assert "password='***'" in repr_str
    assert "cookie='***'" in repr_str

def test_linkedin_config_repr_handles_none():
    """Test that LinkedInConfig.__repr__ handles None values correctly."""
    config = LinkedInConfig(
        email="test@example.com",
        password=None,
        cookie=None
    )

    repr_str = repr(config)

    assert "test@example.com" in repr_str
    assert "password='***'" in repr_str
    assert "cookie=None" in repr_str
